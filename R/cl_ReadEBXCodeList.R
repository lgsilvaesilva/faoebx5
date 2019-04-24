#' @title Read EBX5 Code List
#'
#' @description This function aimed to read code list data from EBX5 to R.
#'
#' @param cl_name code list name which the data will be read from. Please, see
#' the code list options by running the function \code{\link{GetEBXCodeLists}} in the field "Name".
#' @param branch branch name.
#' @param instance instance name.
#'
#' @seealso \code{\link{GetEBXCodeLists}}.
#'
#' @return Return an object of the class \code{\link[data.table]{data.table}}.
#'
#' @importFrom RCurl basicTextGatherer parseHTTPHeader curlPerform
#' @importFrom keyring key_get
#' @importFrom XML getNodeSet xmlToDataFrame xmlParse
#' @import data.table
#'
#' @examples
#' \dontrun{
#' ReadEBXCodeList(cl_name = "ISSCFC")
#' }
#' @export
#'
#' @author Luis G. Silva e Silva, \email{luis.silvaesilva@fao.org}
ReadEBXCodeList <- function(cl_name,
                            branch = "Fishery",
                            instance = "Fishery") {

  if(missing(cl_name)) {
    stop('Please, provide the code list name.')
  }

  .user <- Sys.getenv('USERNAME')

  ##-- SOAP: Header ----
  headerFields <- header_fields()

  ##-- Body: request ----
  body <- body_select_request(.user     = .user,
                              .name     = cl_name,
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
  df  <- xmlToDataFrame(nodes = getNodeSet(doc, paste0("//", cl_name)))
  df  <- data.table::data.table(df)

  return(df)
}
