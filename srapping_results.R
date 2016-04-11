require(jsonlite)

# scrapping results for 2015 general elections from https://resultadosgenerales2015.interior.es

# testing with albacete (province 4)
albacete <- 'https://resultadosgenerales2015.interior.es/congreso/results/ES201512-CON-ES/ES/CA08/02/info.json'

albacete_r <- fromJSON(albacete)
results_albacete <- albacete_r$results$parties[,-8]

# scrape results in a list of 52 provinces (52 dataframes)
url_codes <- 'https://resultadosgenerales2015.interior.es/congreso/assets/seats/CONGRESO.json'
codes <- fromJSON(url_codes)
codes_2015 <- names(codes[[1]])
codes_2015 <- lapply(codes_2015, function(x) strsplit(x, ""))
lengths <- sapply(codes_2015, function(x) length(x[[1]]))
codes_2015 <- names(codes[[1]])[lengths==26]

url_provinces <- 'https://resultadosgenerales2015.interior.es/congreso/config/ES201512-CON-ES/provincia.json'
provinces <- fromJSON(url_provinces)
results_2015 <- list()

for(i in 1:52) {
  
  url_com <- 'https://resultadosgenerales2015.interior.es/congreso/results/'
  url_pro <- codes_2015[i]
  url_end <- '/info.json'
  url <- paste0(url_com, url_pro, url_end)
  
  res <- fromJSON(url)
  num <- unlist(strsplit(url_pro, split=''))
  num <- num[(length(num) - 1):length(num)]
  num <- as.numeric(paste0(num[1], num[2]))
  
  results <- res$results$parties[,-8]
  part <- res$results$voters
  cens <- res$results$census
  results_2015[[num]] <- list(res = results, part = part, cens = cens)
  
}