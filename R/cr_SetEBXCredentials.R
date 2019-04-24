#' @title Set EBX Credentials
#'
#' @param username username, a character scalar.
#'
#' @seealso \code{\link{RemoveEBXCredentials}}.
#'
#' @description This function aimed to set up your EBX credentials.
#' First of all, you have to request the EBX manager to give rights
#' to access EBX. Usually, you will use the same username and password
#' from the Statistical Working System (SWS).
#'
#' @details When you run the function \code{SetEBXCredentials()} will open
#' a box to type your password twice. This function tries to guess your username
#' using the variable stored in the system, Sys.getenv('USERNAME'). Otherwise,
#' you can provide your username by the argument \code{username}.
#'
#' @return Status 0 (zero) ok.
#'
#' @importFrom keyring key_get keyring_list key_set
#' @export
#'
#' @author Luis G. Silva e Silva, \email{luis.silvaesilva@fao.org}
SetEBXCredentials <- function(username) {

  if(!"EBX" %in% keyring::keyring_list()$keyring) {

    if(missing(username)) {
      username <- Sys.getenv('USERNAME')
    } else {
      Sys.setenv('USERNAME' = username)
    }

    keyring::keyring_create(keyring = "EBX")
    keyring::key_set(service = "EBX_SECRET",
                     username = username,
                     keyring = "EBX")

    message('EBX credentials have been SET with success.')
    return(c('OK' = 0))

  } else {

    message('There is already EBX credentials stored.')

  }

}

