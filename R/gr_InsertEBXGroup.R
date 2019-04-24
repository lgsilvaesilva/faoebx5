#' @title Insert rows in EBX5 Group
#'
#' @description This function aimed to insert
#' data rows into a group stored in EBX5 through R.
#'
#' @param data a \code{\link[base]{data.frame}} that will be appended.
#' @param folder folder name in EBX that the code list is stored.  Please, see
#' the code list options by running the function \code{\link{GetEBXGroups}}
#' @inheritParams ReadEBXGroup
#'
#' @seealso \code{\link{GetEBXGroups}}
#'
#' @details Note that the new rows must have the same columns name os the table that will be appended.
#'
#' @return boolean
#'
#' @examples
#'
#' \dontrun{
#' InsertEBXGroup(data = gr_new,
#' gr_name  = 'EBXGroup',
#' folder   = 'Metadata',
#' branch   = 'Fishery',
#' instance = 'Fishery')
#' }
#'
#' @export
#'
#' @importFrom XML addChildren
#'
#' @author Luis G. Silva e Silva, \email{luis.silvaesilva@fao.org}
InsertEBXGroup <- function(data,
                           gr_name,
                           folder,
                           branch = 'Fishery',
                           instance = 'Fishery') {

  .user <- Sys.getenv('USERNAME')

  ##-- SOAP: Header ----
  headerFields <- header_fields()

  ##-- Body: request ----
  body <- body_insert_request(.user = .user,
                              .folder = folder,
                              .cl_name = gr_name,
                              .branch = branch,
                              .instance = instance)

  ##-- Building XML object----
  out_list <- cl_data_insert_xml(.data = data,
                                 .cl_name = gr_name)

  body_xml <- xmlParse(body)
  metadata_xml <- getNodeSet(body_xml, paste0("//", folder))
  metadata_xml[[1]] <- addChildren(metadata_xml[[1]], kids = out_list)
  body_text <- as(body_xml, "character")

  ##-- API request ----
  reader <- basicTextGatherer()
  header <- basicTextGatherer()

  curlPerform(url = headerFields[['SOAPAction']],
              httpheader = headerFields,
              postfields = body_text,
              writefunction = reader$update,
              headerfunction = header$update)

  ##-- Status ----
  h <- parseHTTPHeader(header$value())
  if(!(h['status'] >= 200 & h['status'] <= 300)) {

    stop('Plese, check if you have permission to access this data.')

  } else{

    return(TRUE)

  }

}
