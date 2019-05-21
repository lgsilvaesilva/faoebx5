#' Get EBX Secret
#'
#' @param username EBX username, character
#'
#' @return the username secret stored
#'
#' @importFrom keyring key_list
GetSecret <- function(username) {

  if(missing(username)) {

    stop("username parameter is missing.")

  }

  users_ebx_lock <- keyring::key_list(service = "EBX_SECRET", keyring = "EBX")
  users_ebx_unlocked <- keyring::key_list(service = "EBX_SECRET")

  if (username %in% users_ebx_lock$username) {

    .secret <- keyring::key_get("EBX_SECRET", username = username, keyring = "EBX")
    return(.secret)

  }

  if (username %in% users_ebx_unlocked$username) {

    .secret <- keyring::key_get("EBX_SECRET", username = username)
    return(.secret)

  }

}

