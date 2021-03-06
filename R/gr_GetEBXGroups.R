#' @title Get EBX Groups
#'
#' @description This function aimed to get the list of groups
#' available in the EBX5 to be read from using the function
#' \code{\link{ReadEBXGroup}}.
#'
#' @inheritParams ReadEBXGroup
#'
#' @seealso \code{\link{ReadEBXGroup}}
#'
#' @return Returns an object of the class \code{\link[data.table]{data.table}}
#'
#' @importFrom RCurl basicTextGatherer parseHTTPHeader curlPerform
#' @importFrom keyring key_get
#' @importFrom XML getNodeSet xmlToDataFrame xmlParse
#' @import data.table
#'
#' @examples
#'
#' \dontrun{
#' GetEBXGroups()
#' }
#' @export
#'
#' @author Luis G. Silva e Silva, \email{luis.silvaesilva@fao.org}
GetEBXGroups <- function(branch = 'Fishery', instance = 'Fishery') {

  .user <- Sys.getenv('USERNAME_EBX')


  ##-- SOAP: Header ----
  headerFields <- header_fields()

  ##-- Body: request ----
  body <- body_get_request(.user = .user,
                           .type = 'EBXGroup',
                           .branch = branch,
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

    doc <- xmlParse(reader$value())
    df  <- xmlToDataFrame(getNodeSet(doc, "//SOAP-ENV:Fault"), stringsAsFactors = F)
    msg <- paste(names(df), ": ", df[1,], collapse = "\n", sep = '')

    stop('Please, check if you have permission to access this data.\n\n',
         'Details:\n', msg)
  }

  ##--- Converting XML object to dataframe ----
  doc <- xmlParse(reader$value())
  df  <- xmlToDataFrame(nodes = getNodeSet(doc, "//EBXGroup"))
  df  <- data.table::data.table(df)

  return(df)
}
