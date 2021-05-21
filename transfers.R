library(rvest)
library(httr)
library(XML)
library(readxl)
setwd("~/Downloads")
rm(list = ls())

#Questions: 
## 1. What's the cut off for a successful transfer? 
### Do you have an idea of what would indicate they would be successful at BYU?
### If not, is there a way we could look at their stats at their new school with a cut off 
#### and then let the model figure it out?
## 2. Do you care about committed transfers?
## 3. What stats/metrics do you care about?
## 4. What do you want right now, and what would you love to have in the future? 

### pulling transfer names from 247 sports ####

url <- "https://247sports.com/Season/2021-Basketball/TransferPortal/"
url2 <- "https://247sports.com/Season/2021-Basketball/TransferPortal/?status=uncommitted"
html <- read_html(url)
html2 <- read_html(url2)


dat <- html %>% 
  html_nodes(".portal-list_itm .player a") %>% 
  html_text() %>% 
  matrix()

dat2 <- html2 %>% 
  html_nodes(".portal-list_itm .player a") %>% 
  html_text() %>% 
  matrix()



### pulling player stats from basketball reference ###

players <- read_excel("transfers.xlsx", sheet = "Transfers")
avail_players <- players[which(players$to_transfer == "Available"),c(1,5,7:8)]

cbb_url <- "https://www.sports-reference.com/cbb/players/"

avail_player_df <- list()

for (i in 1:length(avail_players$player)) {
  
  player_url <- paste0(cbb_url, avail_players$bb_link[i], ".html")
  tryCatch(
    {
      player_html <- read_html(player_url)
      
      player_stats <- player_html %>% 
        html_nodes("#players_per_game") %>%
        html_table()
      
      # player_stats <- player_html %>% 
      #   html_nodes("#players_advanced") %>% 
      #   html_table()
      
      avail_player_df[[i]] <- player_stats[[1]]
      
    }, error = function(cond) {
      print(paste0("error on ", avail_players$player[i]))
      print(player_url)
      return(NA)
    })
  
 

}

### byu transfers - pulling stats ###

byu_players <- read_excel("transfers.xlsx", sheet = "BYU")

byu_df <- list()

for (i in 1:length(byu_players$player)) {
  
  player_url <- paste0(cbb_url, byu_players$bb_link[i], ".html")
  tryCatch(
    {
      player_html <- read_html(player_url)
      
      player_stats <- player_html %>% 
        html_nodes("#players_per_game") %>%
        html_table()
      
      # player_stats <- player_html %>% 
      #   html_nodes("#players_advanced") %>% 
      #   html_table()
      
      byu_df[[i]] <- player_stats[[1]]
      
    }, error = function(cond) {
      print(paste0("error on ", byu_players$player[i]))
      print(player_url)
      return(NA)
    })
  
  
  
}

rm(player_html)
rm(i)
rm(player_url)
rm(player_stats)



























##################################################STUFF#########################################################

# handle <- handle("https://www.espn.com/mens-college-basketball/insider/story/_/id/30820857/college-basketball-transfer-rankings-2021-22#") 
# path   <- "amember/login.php"
# 
# # fields found in the login form.
# login <- list(
#   amember_login = "username"
#   ,amember_pass  = "password"
#   ,amember_redirect_url = 
#     "http://subscribers.footballguys.com/myfbg/myviewprojections.php?projector=2"
# )
# 
# response <- POST(handle = handle, path = path, body = login)

# transfer_url <- "https://www.espn.com/mens-college-basketball/insider/story/_/id/30820857/college-basketball-transfer-rankings-2021-22"
# transfer_html <- read_html(transfer_url)
# 
# player_links <- transfer_html %>% 
#   html_nodes("a") %>% 
#   html_attr("href")




