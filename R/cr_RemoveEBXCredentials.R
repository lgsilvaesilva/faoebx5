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
#' @importFrom keyring key_get keyring_list key_set key_list
#' @export
#'
#' @author Luís G. Silva e Silva, \email{luis.silvaesilva@fao.org}
RemoveEBXCredentials <- function(username) {


  #'credential stored in the EBX file
  users_ebx_lock <- keyring::key_list(service = 'EBX_SECRET', keyring = "EBX")

  #' credentials stored in the default variable
  users_ebx_unlocked <- keyring::key_list()

  if (!username %in% c(users_ebx_lock$username, users_ebx_unlocked$username)) {

    stop("There are no crendetials to be removed for the username: *", username, "*.")

  }

  if (username %in% users_ebx_lock$username) {

    keyring::key_delete(service = 'EBX_SECRET', username = username, keyring = 'EBX')

    message('EBX credentials have been REMOVED with success for the username *', username , '*.')

    return(c('OK' = 0))
  }

  if (username %in% users_ebx_unlocked$username) {

    keyring::key_delete(service = 'EBX_SECRET', username = username)

    message('EBX credentials have been REMOVED with success for the username *', username , '*.')

    return(c('OK' = 0))
  }




}
