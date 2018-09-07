


shiny::runApp(appDir = "C:/Users/mcolvin/Documents/projects/gcpo-lcc/GCPO-species-app")


## DEPLOTY TO SHINYAPPS
rsconnect::setAccountInfo(name='mcolvin',
			  token='3B307455E645B290C41D70433D032BA9',
			  secret='SjihTAUOpIi4zzrBEQmAVXPPShEWsAXvR7sXIecA')
rsconnect::deployApp(appDir = "C:/Users/mcolvin/Documents/projects/gcpo-lcc/GCPO-species-app",
    launch.browser = TRUE)