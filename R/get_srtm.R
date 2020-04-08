#' Get the SRTM1 elevation data
#'
#' @param latitude
#' @param longitude
#'
#' @return
#' @internal
get_srtm <- function(latitude, longitude){

  suppressWarnings({
    tibble::tibble(lat = latitude,
                   lon = longitude) %>%
      split(.,
            f = rep(1:ceiling(nrow(.)/20), each = 20)) %>%
      purrr::map_dfr(function(x){
        httr::GET("http://api.geonames.org/srtm1",
                  query = list(lats = paste0(x$lat, collapse = ","),
                               lngs = paste0(x$lon, collapse = ","),
                               username = "rbocinsk")) %>%
          httr::content(type = "text/csv",
                        encoding = "UTF-8",
                        col_names = FALSE,
                        col_types = readr::cols(
                          X1 = readr::col_double()
                        ))
      }) %>%
      dplyr::mutate(X1 = dplyr::na_if(X1, -32768)) %>%
      magrittr::extract2(1)
  })

}
