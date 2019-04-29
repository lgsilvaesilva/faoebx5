#' @title Remove EBX Credentials
#'
#' @param username username, a character scalar.
#'
#' @seealso \code{\link{SetEBXCredentials}}.
#'
#' @description This function aimed to remove your EBX credentials previously
#' created using the function \code{\link{SetEBXCredentials}}.
#'
#' @details When you run the function \code{RemoveEBXCredentials()} will open
#' a box to type your password twice. This function tries to guess your username
#' using the variable stored in the system, Sys.getenv('USERNAME'). Otherwise,
#' you can provide your username by the argument \code{username}.
#'
#' @return Status 0 (zero) ok.
#'
#' @importFrom keyring key_get keyring_list key_set
#' @export
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
RemoveEBXCredentials <- function(username) {

  if("EBX" %in% keyring::keyring_list()$keyring) {

    if(missing(username)) {

      username <- Sys.getenv('USERNAME')

    }

    keyring::key_delete(service = 'EBX_SECRET',
               username = username,
               keyring = 'EBX')

    keyring::keyring_delete('EBX')

    message('EBX credentials have been REMOVED with success.')

    return(c('OK' = 0))

  } else {

    message('There is no EBX credentials to be removed.')

  }

}
