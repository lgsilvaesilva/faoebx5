#' @title Read EBX5 Group
#'
#' @description This function aimed to read group data from EBX5 to R.
#'
#' @param gr_name group name which the data will be read from.  Please, see
#' the code list options after run the function \code{\link{GetEBXGroups}} in the field "Name".
#' @param branch branch name.
#' @param instance instance name.
#'
#' @seealso \code{\link{GetEBXGroups}}.
#'
#' @return Return an object of the class \code{\link[data.table]{data.table}}.
#'
#' @importFrom RCurl basicTextGatherer parseHTTPHeader curlPerform
#' @importFrom keyring key_get
#' @importFrom XML getNodeSet xmlToDataFrame xmlParse
#' @import data.table
#'
#' @examples
#'
#' \dontrun{
#' gr <- ReadEBXGroup(gr_name = 'Group_CPCDiv_CPCGroup')
#' }
#'
#' @export
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
ReadEBXGroup <- function(gr_name,
                         branch = 'Fishery',
                         instance = 'Fishery') {

  if(missing(gr_name)) {
    stop('Please, provide the group name.')
  }

  .user <- Sys.getenv('USERNAME')

  ##-- SOAP: Header ----
  headerFields <- header_fields()

  ##-- Body: request ----
  body <- body_select_request(.user     = .user,
                              .name     = gr_name,
                              .branch   = branch,
                              .instance = instance)

  ##-- API request ----
  reader <- basicTextGatherer()
  header <- basicTextGatherer()

  curlPerform(url = headerFields["SOAPAction"],
              httpheader = headerFields,
              postfields = body,
              writefunction = reader$update,
              headerfunction = header$update)

  ##-- Status ----
  h <- parseHTTPHeader(header$value())
  if(!(h['status'] >= 200 & h['status'] <= 300)) {

    stop('Plese, check if you have permission to access this data.')

  }

  ##--- Converting XML object to dataframe ----
  doc <- xmlParse(reader$value())
  df  <- xmlToDataFrame(nodes = getNodeSet(doc, paste0("//", gr_name)))
  df  <- data.table::data.table(df)

  return(df)
}
