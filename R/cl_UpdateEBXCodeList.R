#' @title Update rows in EBX5 Code List
#'
#' @description This function aimed to update
#' data rows into a code list stored in EBX5 through R.
#'
#' @inheritParams InsertEBXCodeList
#'
#' @return boolean
#'
#' @details Note that the udpated rows must have the same columns name os the table that will be updated.
#'
#' @examples
#'
#' \dontrun{
#' cl_new <- data.frame(
#' Identifier = c(999, 888),
#' Acronym = 'TEST_ACRONYM',
#' Folder = 'TESTFOLDER',
#' Name = 'TEST_NAME',
#' Branch = 'Fishery',
#' Instance = 'Fishery')
#'
#' UpdateEBXCodeList(data     = cl_new,
#'                   cl_name  = 'EBXCodelist',
#'                   folder   = 'Metadata',
#'                   branch   = 'Fishery',
#'                   instance = 'Fishery')
#' }
#'
#' @export
#'
#' @importFrom XML addChildren
#'
#' @author Luis G. Silva e Silva, \email{luis.silvaesilva@fao.org}
UpdateEBXCodeList <- function(data,
                              cl_name,
                              folder,
                              branch = 'Fishery',
                              instance = 'Fishery') {

  .user <- Sys.getenv('USERNAME_EBX')

  ##-- SOAP: Header ----
  headerFields <- header_fields()

  ##-- Body: request ----
  body <- body_update_request(.user = .user,
                              .name = cl_name,
                              .folder = folder,
                              .branch = branch,
                              .instance = instance)

  ##-- Building XML object----
  out_list <- cl_data_insert_xml(.data = data,
                                 .cl_name = cl_name)

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

    doc <- xmlParse(reader$value())
    df  <- xmlToDataFrame(getNodeSet(doc, "//SOAP-ENV:Fault"), stringsAsFactors = F)
    msg <- paste(names(df), ": ", df[1,], collapse = "\n", sep = '')

    stop('Please, check if you have permission to access this data.\n\n',
         'Details:\n', msg)
  } else{

    return(TRUE)

  }

}
