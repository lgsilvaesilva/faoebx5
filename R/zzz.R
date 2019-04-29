.onLoad <- function(libname, pkgname){

  username <- Sys.getenv('USERNAME')
  Sys.setenv('USERNAME_EBX' = username)

}
