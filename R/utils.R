#' @title Header Fields
#'
#' @description Builds the header fields
#'
#' @param soap_action EBX5 SOAP URL to API requests
#'
#' @return character with the header fields
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
header_fields <- function(soap_action) {

  if(missing(soap_action)) {
    soap_action <- "http://hqldvebx1.hq.un.fao.org:8080/ebx-dataservices/connector"
  }

  header <- c(Accept = "text/xml",
              Accept = "multipart/*",
              `Content-Type` = "text/xml; charset=utf-8",
              SOAPAction = soap_action)

  return(header)
}

#' @title XXX
#'
#' @description XXX
#'
#' @param .data XXX
#' @param .cl_name code list name which the data will be read from. Please, see
#' the code list options by running the function \code{\link{GetEBXCodeLists}}
#' @return XXX
#'
#' @importFrom XML newXMLNode
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
cl_data_insert_xml <- function(.data,
                               .cl_name = 'EBXCodelist') {

  features <- names(.data)
  out_list <- list()

  for(j in 1:nrow(.data)) {

    out_list[[j]] <- newXMLNode(name = .cl_name)

    for(i in 1:ncol(.data)) {
      newXMLNode(name = features[i], .data[j, i], parent = out_list[[j]])
    }
  }

  return(out_list)
}

#' @title Builds the XML body to insert data
#'
#' @description Builds the XML body to insert data.
#'
#' @param .user username
#' @param .branch branch name
#' @param .instance intance name
#' @param .folder folder name
#' @inheritParams cl_data_insert_xml
#'
#' @return character
#'
#' @importFrom keyring key_get
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
body_insert_request <- function(.user,
                                .cl_name,
                                .folder = "Metadata",
                                .branch,
                                .instance) {

  .secret <- GetSecret(username = .user)

  body <- sprintf('<?xml version="1.0" encoding="utf-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sec="http://schemas.xmlsoap.org/ws/2002/04/secext" xmlns:urn="urn:ebx-schemas:dataservices_1.0">
                  <soapenv:Header>
                  <sec:Security>
                  <UsernameToken>
                  <Username>%s</Username>
                  <Password>%s</Password>
                  </UsernameToken>
                  </sec:Security>
                  </soapenv:Header>
                  <soapenv:Body>
                  <urn:insert_%s>
                  <branch>%s</branch>
                  <instance>%s</instance>
                  <data>
                  <root>
                  <@folder@></@folder@>
                  </root>
                  </data>
                  </urn:insert_%s>
                  </soapenv:Body>
                  </soapenv:Envelope>',
                  .user,
                  .secret,
                  .cl_name,
                  .branch,
                  .instance,
                  .cl_name)

  body <- gsub("@folder@", .folder, body)

  return(body)
}

#' @title Builds the XML body to remove data
#'
#' @description Builds the XML body to remove data
#'
#' @inheritParams body_insert_request
#'
#' @return character
#'
#' @importFrom keyring key_get
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
body_remove_request <- function(.user,
                                .cl_name,
                                .folder = "Metadata",
                                .branch,
                                .instance) {

  .secret <- GetSecret(username = .user)

  body <- sprintf('<?xml version="1.0" encoding="utf-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sec="http://schemas.xmlsoap.org/ws/2002/04/secext" xmlns:urn="urn:ebx-schemas:dataservices_1.0">
                  <soapenv:Header>
                  <sec:Security>
                  <UsernameToken>
                  <Username>%s</Username>
                  <Password>%s</Password>
                  </UsernameToken>
                  </sec:Security>
                  </soapenv:Header>
                  <soapenv:Body>
                  <urn:delete_%s>
                  <branch>%s</branch>
                  <instance>%s</instance>
                  <data>
                  <root>
                  <@folder@></@folder@>
                  </root>
                  </data>
                  </urn:delete_%s>
                  </soapenv:Body>
                  </soapenv:Envelope>',
                  .user,
                  .secret,
                  .cl_name,
                  .branch,
                  .instance,
                  .cl_name)

  body <- gsub("@folder@", .folder, body)

  return(body)
}


#' @title Builds the XML body to update data
#'
#' @description Builds the XML body to update data
#'
#' @inheritParams body_insert_request
#' @param .name code list or group name.
#'
#' @return character
#'
#' @importFrom keyring key_get
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
body_update_request <- function(.user,
                                .name,
                                .folder = "Metadata",
                                .branch,
                                .instance) {

  .secret <- GetSecret(username = .user)

  body <- sprintf('<?xml version="1.0" encoding="utf-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sec="http://schemas.xmlsoap.org/ws/2002/04/secext" xmlns:urn="urn:ebx-schemas:dataservices_1.0">
                  <soapenv:Header>
                  <sec:Security>
                  <UsernameToken>
                  <Username>%s</Username>
                  <Password>%s</Password>
                  </UsernameToken>
                  </sec:Security>
                  </soapenv:Header>
                  <soapenv:Body>
                  <urn:update_%s>
                  <branch>%s</branch>
                  <instance>%s</instance>
                  <data>
                  <root>
                  <@folder@></@folder@>
                  </root>
                  </data>
                  </urn:update_%s>
                  </soapenv:Body>
                  </soapenv:Envelope>',
                  .user,
                  .secret,
                  .name,
                  .branch,
                  .instance,
                  .name)

  body <- gsub("@folder@", .folder, body)

  return(body)

}

#' @title Builds the XML body to select data
#'
#' @description Builds the XML body to select data
#'
#' @inheritParams body_insert_request
#' @param .name code list or group name.
#'
#' @return character
#'
#' @importFrom keyring key_get
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
body_select_request <- function(.user, .name, .branch, .instance) {

  .secret <- GetSecret(username = .user)

  body <- sprintf('<?xml version="1.0" encoding="utf-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sec="http://schemas.xmlsoap.org/ws/2002/04/secext" xmlns:urn="urn:ebx-schemas:dataservices_1.0">
                  <soapenv:Header>
                  <sec:Security>
                  <UsernameToken>
                  <Username>%s</Username>
                  <Password>%s</Password>
                  </UsernameToken>
                  </sec:Security>
                  </soapenv:Header>
                  <soapenv:Body>
                  <urn:select_%s>
                  <branch>%s</branch>
                  <instance>%s</instance>
                  </urn:select_%s>
                  </soapenv:Body>
                  </soapenv:Envelope>',
                  .user,
                  .secret,
                  .name,
                  .branch,
                  .instance,
                  .name)

  return(body)
}

#' @title Builds the XML body to insert data
#'
#' @description Builds the XML body to insert data
#'
#' @param .type data source, EBXCodelist or EBXGroup
#' @inheritParams body_insert_request
#'
#' @return character
#'
#' @importFrom keyring key_get
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
body_get_request <- function(.user, .type, .branch, .instance) {

  .secret <- GetSecret(username = .user)

  body <- sprintf('<?xml version="1.0" encoding="utf-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sec="http://schemas.xmlsoap.org/ws/2002/04/secext" xmlns:urn="urn:ebx-schemas:dataservices_1.0">
                  <soapenv:Header>
                  <sec:Security>
                  <UsernameToken>
                  <Username>%s</Username>
                  <Password>%s</Password>
                  </UsernameToken>
                  </sec:Security>
                  </soapenv:Header>
                  <soapenv:Body>
                  <urn:select_@type@>
                  <branch>%s</branch>
                  <instance>%s</instance>
                  </urn:select_@type@>
                  </soapenv:Body>
                  </soapenv:Envelope>',
                  .user,
                  .secret,
                  .branch,
                  .instance)

  body <- gsub(pattern = '@type@', replacement = .type, x = body)

  return(body)
}



