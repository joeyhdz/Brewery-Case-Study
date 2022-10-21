library(tidyverse)
library(ggplot2)
library(janitor)
library(usmap)
library(caret)
library(e1071)
library(class)
beer_data <-read.csv("C:/Users/Joey/Desktop/DDS_Work/Unit - 8/Beers.csv")
brew_data <- read.csv("C:/Users/Joey/Desktop/DDS_Work/Unit - 8/Breweries.csv")

#################### Exploring Raw Data ###########################
# check rows
head(beer_data)
head(brew_data)

# rename columns for merging 
names(beer_data)[1] <- 'beer_name'
names(brew_data)[2] <- 'Brew_name'
names(brew_data)[1]<- 'Brewery_id'


# checking for missing values beer 
sapply(beer_data,function(x) sum(is.na(x))/nrow(beer_data))
sapply(beer_data,function(x) sum(x== ""))
# checking for missing values brew

sapply(brew_data,function(x) sum(is.na(x))/nrow(brew_data))
sapply(brew_data,function(x) sum(x== ""))

# addressing the missing values from beer
beer_data[854,'Style'] = "Scottish Ale"
beer_data[867, 'Style'] = 'Marzen'



# looking for duplicates in data 
brew_data %>% get_dupes(Brewery_id)
brew_data %>% get_dupes(Brew_name)
beer_data %>% get_dupes(beer_name)
beer_data %>% get_dupes(Brewery_id)
beer_data %>% get_dupes(Beer_ID)

# addresses the duplicates in brew_data 
brew_data<- brew_data[-c(96,378,262,139),] 

# addresses the duplicates in beer_data
beer <- beer_data[!duplicated(beer_data$beer_name),]
beer %>% get_dupes(Brewery_id) # these duplicates are for various drinks from the same brew id
beer %>% get_dupes(Beer_ID) # fixed
beer %>% get_dupes(beer_name)

# gets rid of the white space before the State abb. 
brew_data$State<-trimws(brew_data$State, "left")


# merging beer and brew_data - with an inner join
beer_brew <- merge(brew_data, beer, by ='Brewery_id')


################################### Question 1 ##################################

# this gets only one brewery name so that we don't have multiple brew representation because 
# of the multiple drinks served by that one location. 
state_num_data <- beer_brew[!duplicated(beer_brew$Brew_name),]

# the n_distinct takes care of the potential repeat brew representation making last line redundant
# but kept in as precautionary measure.
state_brew_plot <- state_num_data %>% group_by(State) %>%
  summarise(num_brew = n_distinct(Brew_name),
  mean_abv = mean(ABV), mean_ibu = mean(IBU)) %>%
  arrange(desc(num_brew))

state_brew_plot

# changes column State to state to satisfy the usmap argument
names(state_brew_plot)[1] <- 'state'

# makes into dataframe
state_brew_plot <- as.data.frame(state_brew_plot)

# plot of the Concentration of Breweries in the US
plot_usmap(data=state_brew_plot[,1:2],
           regions = "states",
           labels = TRUE,label_color = "black",
           values = "num_brew") +
          scale_fill_gradient(low = 'white', high = 'red')+
          labs(title = 'Distribution of Breweries across the United States',
               fill = "Brewery \nAmount") +
          theme(legend.position = "right") 
    

################################### Question 3 ##################################
################################### Question 4 ##################################

# this will return medians for each state ( NA NOT INCLUDED )
state_medians <- beer_brew %>% group_by(State) %>%
  summarise(num_brew = n_distinct(Brew_name),
            median_abv = median(ABV, na.rm = TRUE), median_ibu = median(IBU, na.rm = TRUE)) %>%
  arrange(desc(num_brew))

# to return the medians data
state_medians

# convert to data frame
state_medians <- as.data.frame(state_medians)

# plot Median ABV
state_medians %>% ggplot(aes(x = reorder(State, desc(median_abv)), y = median_abv, fill = State))+
  geom_bar(stat='identity')+
  coord_flip()

# plot Median IBU
state_medians %>% ggplot(aes(x = reorder(State, desc(median_ibu)), y = median_ibu, fill = State))+
  geom_bar(stat = 'identity') +
  coord_flip()


################################### Question 5 ##################################
# this is not very helpful... 
# plot for ABV
max_abv <- beer_brew %>% select(ABV, State)

max_abv %>% ggplot(aes(ABV, fill = State)) +
  geom_bar(stat = 'count')+
  coord_flip()

max_abv %>% ggplot(aes(ABV, color = State)) + 
  geom_point(stat = 'count')

# plot for IBU
max_ibu <- beer_brew %>% select(IBU, State)

max_ibu %>% ggplot(aes(IBU, fill = State)) +
  geom_bar(stat = 'count')+
  coord_flip()
################################### Question 6 ##################################

abv_dis_plot <- beer_brew %>% select(ABV,Style)
abv_dis_plot %>% ggplot(aes(ABV)) +
  geom_histogram(color = 'black',aes(fill = 'red'), alpha = .5, show.legend = FALSE) +
  ggtitle('Distribution of the Alcohol by Volume Content in Beer From Various Breweries')+
  ylab('Frequency') + xlab('Alcohol by Volume')

################################### Question 7 ##################################

ibu_abv_plot <- beer_brew %>% select(IBU,ABV,Style)

ibu_abv_plot %>% ggplot(aes(x = ABV, y = Style)) +
  geom_point(aes(color = 'red'), position = "identity") +
  geom_point(aes(IBU, Style), color='blue')

ibu_abv_plot %>% ggplot(aes(x = ABV, y = IBU))+
  geom_point()+
  geom_smooth(se=FALSE)
             



################################### KNN Prediction Model Data #########################

# test to see how the model will work using beer_brew

# make a Dataframe without NA so that we can run KNN:
beer_predict <- na.omit(beer_brew)
# sanity check 
#view(beer_predict)

# simple test to see if the data works together within the KNN function
my_beer_test <- data.frame(IBU = c(.05, .04, .043), ABV = c(.06, .055, .065))
knn(beer_predict[,c(7,8)], my_beer_test, beer_predict$Style, k = 3, prob = TRUE)


# viewing what matches each of these strings will return before filtering. 
(str_view_all(beer_predict$Style, 'Ale', match = TRUE))
(str_view_all(beer_predict$Style, 'IPA', match = TRUE))

# creating test variable to call so we can see if the filter works
#test_ale_filter <- beer_predict %>% filter(str_detect(Style, 'Ale'))
#view(test_ale_filter$Style) # viewing the filter for effectiveness

# repeating the same process for the IPA
#test_ipa_filter <- beer_predict %>% filter(str_detect(Style, 'IPA'))
#view(test_ipa_filter$Style) # viewing the filter for effectiveness 

# using both filters above to create one combo test filter
#test_combo_filter<- beer_predict %>% filter(str_detect(Style, 'IPA') | str_detect(Style, "Ale"))
#view(test_combo_filter$Style)


# creating the finalized data frame to use for test/train split etc. 
beer_predict_fin <- beer_predict %>% filter(str_detect(Style, 'IPA') | str_detect(Style, "Ale"))
glimpse(beer_predict_fin)

################################### KNN Test Train Split & initial run #########################

#checking dimensions to understand what our test/train will look like
glimpse(beer_predict_fin)
(nrow(beer_predict_fin)) # total 887 rows
(round(nrow(beer_predict_fin)*.3)) # total 177


set.seed(765)
intrain <- sample(nrow(beer_predict_fin), round(nrow(beer_predict_fin)*.30))
beer_train <- beer_predict_fin[intrain,]
beer_test <- beer_predict_fin[-intrain,]

# setting up the classification 
classification <- knn(beer_train[,c(7,8)],
                      beer_test[,c(7,8)],
                      beer_train$Style,
                      k = 3, prob = TRUE)

# setting up a passable data for confusion matrix 
u <- union(classification, beer_test$Style)
t <- table(factor(classification, u), factor(beer_test$Style, u))

# confusion matrix for more stats on the model
confusionMatrix(t)


################################### KNN finding best K #########################

iterations = 50
num_of_k = 50
split_percent = .3

model_accuracy = matrix(nrow = iterations, ncol = num_of_k)
model_specificity = matrix(nrow = iterations, ncol = num_of_k)
model_sensitivity = matrix(nrow = iterations, ncol = num_of_k)

for (j in 1:iterations)
{
  set.seed(765)
  intrain2 <- sample(nrow(beer_predict_fin), round(nrow(beer_predict_fin)*split_percent))
  train2 <- beer_predict_fin[intrain2,]
  test2 <- beer_predict_fin[-intrain2,]
  for(i in 1:num_of_k)
  {
    classify = knn(train2[,c(7,8)],
                   test2[,c(7,8)],
                   train2$Style,
                   k = i, prob = TRUE)
    u = union(classify, test2$Style)
    t = table(factor(classify, u), factor(test2$Style, u))
    CM = confusionMatrix(t)
    model_accuracy[j,i] = CM$overall[1]
    model_specificity[j,i] = CM$byClass[1]
    model_sensitivity[j,i] = CM$byClass[2]
  }
  
  
}
CM
mean_accuracy = colMeans(model_accuracy)
mean_specificity = colMeans(model_specificity)
mean_sensitivity = colMeans(model_sensitivity)

plot(seq(1,num_of_k,1),
     mean_accuracy, type = "l",
     xlab = "Kth value 1:50",
     ylab = "Mean value of measured Accuracy")

plot(seq(1, num_of_k, 1),
     mean_specificity,
     type = 'l',
     xlab = "Kth value 1:50",
     ylab = "Mean value of measured Specifity")

plot(seq(1, num_of_k, 1),
     mean_sensitivity, type = 'l',
     xlab = "Kth value 1:50",
     ylab = "Mean value of measured Sensitivity")

############################ EXTRA EDA ######################################
# vis for 16 ounces 
beer_brew %>% select(Ounces, ABV, IBU, State, Brewery_id) %>% filter(Ounces == 16) %>% ggplot(aes(State,Ounces, fill = State))+
  geom_bar(stat = 'identity',show.legend = FALSE)


beer_brew %>% select(Ounces) %>% ggplot(aes(Ounces))+
  geom_histogram(fill = 'light blue', color = 'black')



beer_brew %>% select(City, State, IBU, ABV, Style, Ounces) %>% filter(State == "TX") %>%
  ggplot(aes(City, ABV, color = City))+
  geom_point(show.legend = FALSE) +
  coord_flip()+
  ggtitle("Scatter Plot of Alcohol by Volume Offered in Cities Across Texas") +
  ylab('Alcohol by Volume (ABV) in Percent %') +
  xlab('Texas Cities')




