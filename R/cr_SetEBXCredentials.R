#' @title Set EBX Credentials
#'
#' @param username username, a character.
#' @param password password, a character.
#' @param lock logical, default is FALSE. If it is TRUE, will store a locked file with the password,
#' and whenever trying to use the credential will ask for the password to unlock the data.
#' @param new logical, default is TRUE. It indicates whether will be set credentials to a new user.
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
SetEBXCredentials <- function(username, password, lock = FALSE, new = TRUE) {

  if(!new) {

    if(missing(username)) {

      username <- Sys.getenv('USERNAME')
      Sys.setenv('USERNAME_EBX' = username)

    } else {

      Sys.setenv('USERNAME_EBX' = username)

    }

    message('EBX credentials have been SET with success for the username: *', username, '*.')
    return(c('OK' = 0))

  }

  if(missing(username)) {

    username <- Sys.getenv('USERNAME')
    Sys.setenv('USERNAME_EBX' = username)

  } else {

    Sys.setenv('USERNAME_EBX' = username)

  }

  if(lock) {

    if(!"EBX" %in% keyring::keyring_list()$keyring) {

    message("Enter password to lock EBX credentials")
    keyring::keyring_create(keyring = "EBX")
    keyring::keyring_lock("EBX")

    }

    # ebx_key_list <- keyring::key_list(service = "EBX_SECRET", "EBX")

    if (missing(password)) {

      keyring::key_set(service = "EBX_SECRET",
                       username = username,
                       keyring = "EBX")

      message('EBX credentials have been SET with success.')
      return(c('OK' = 0))

    } else {

      keyring::key_set_with_value(service = "EBX_SECRET",
                                  username = username,
                                  password = password,
                                  keyring = "EBX")

      message('EBX credentials have been SET with success.')
      return(c('OK' = 0))

    }

  } else {

    if (missing(password)) {

      keyring::key_set(service = "EBX_SECRET",
                       username = username)

      message('EBX credentials have been SET with success.')
      return(c('OK' = 0))

    } else {

      keyring::key_set_with_value(service = "EBX_SECRET",
                                  username = username,
                                  password = password)

      message('EBX credentials have been SET with success.')
      return(c('OK' = 0))

    }

  }



}

