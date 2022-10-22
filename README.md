# Brewery-Case-Study
Doing Data Science Project 1 Case Study - Beer and Brewery Datasets

![Beer   brewery (250 × 250 px)(2)](https://user-images.githubusercontent.com/81498617/197314814-f3e08e0a-38c5-4514-a82c-cd1707ce3060.png)![Beer   brewery (250 × 250 px)(1)](https://user-images.githubusercontent.com/81498617/197314711-1663954e-8e2a-4ed1-a17b-472974db75e8.png)


The purpose of this project was to create a presentation for a hypothetical audience of the Budweiser CEO and CFO.
The goal was to address address the 9 questions / items described below. 
1. How many breweries are present in each state?
2. Merge beer data with the breweries data. Print the first 6 observations and the last six observations to check the merged file.
3. Address the missing values in each column.
4. Compute the median alcohol content and international bitterness unit for each state. Plot a bar chart to compare.
5. Which state has the maximum alcoholic (ABV) beer? Which state has the most bitter (IBU) beer?
6. Comment on the summary statistics and distribution of the ABV variable.
7. Is there an apparent relationship between the bitterness of the beer and its alcoholic content? Draw a scatter plot.
make your best judgment of a relationship and EXPLAIN your answer.
8. Budweiser would also like to investigate the difference with respect to IBU and ABV between IPAs (India Pale Ales)
and other types of Ale (any beer with “Ale” in its name other than IPA).
You decide to use KNN classification to investigate this relationship.  Provide statistical evidence one way or the other.
You can of course assume your audience is comfortable with percentages. 
9. Find one other useful inference from the data that you feel Budweiser may be able to find value in.
You must convince them why it is important and back up your conviction with appropriate statistical evidence. 
# How Many Breweries Are Present in Each State?
![image](https://user-images.githubusercontent.com/81498617/197311345-cf9cc72e-6f1a-4073-907a-d410f4d1f802.png)
# Compute the Median Alcohol Content and International Bitterness Unit for Each State. Plot a Bar Chart to Compare.
The median values of Alcohol content and International Bitterness Units are displayed in the tables below. 
It is worth mentioning that  the missing ABV and IBU values effect the presence of breweries on the map. 
This change in visualization is due to the missing values not being included in the median calculations which effects the representation of that data on the map.
A specific example of this would be the removal (grayed out portion) of South Dakota when visualizing the results for the median IBU. 
![image](https://user-images.githubusercontent.com/81498617/197311466-3c665248-4c6c-4079-9f39-92f7b5c73357.png)
![image](https://user-images.githubusercontent.com/81498617/197311477-15c0840c-1b10-42b3-848f-4da569b9472b.png)
![image](https://user-images.githubusercontent.com/81498617/197311481-52fdf1ea-af8d-48af-9ac9-8d56ea838273.png)
![image](https://user-images.githubusercontent.com/81498617/197311487-86ae123b-f7c7-4aa9-8736-10843804247f.png)
# Is There an Apparent Relationship Between the Bitterness of the Beer and Its Alcoholic Content? Draw a Scatter Plot.
It appears that there is a positive relationship between the bitterness of beer and its alcoholic content. 
We can visualize on a scatter plot that as the bitterness rating increases there tends to be an increase in Alcohol by Volume Percentage (ABV). 
We created a series of scatter plots that would help clean up the visualization of the relationship between IBU and ABV as they relate to different styles.
These plots are below:

First this plot shows us the general relationship with all styles included:
![image](https://user-images.githubusercontent.com/81498617/197311567-b17869cd-4802-4048-b2d9-374365fab39b.png)


This visualization is the same but filtered for only IPA beverages:
![image](https://user-images.githubusercontent.com/81498617/197311572-bccffb75-91a9-4cb1-9885-d62970a7e434.png)


Below you will see a scatter plot filtered to visualize the same ABV, IBU relationship with only Ale beverages.
![image](https://user-images.githubusercontent.com/81498617/197311576-e16497a8-e4de-4c5f-819b-0a6129cf86bd.png)


Finally this scatter plot displays the ABV, IBU relationship with styles filterd to include every type that is NOT IPA, or Ale:
![image](https://user-images.githubusercontent.com/81498617/197311582-857b9d76-3b78-4f22-819e-33ed972d13ef.png)


It appears that across most styles of beer there is a positive relationship between IBU and ABV.
It is worth discussing however the "Ale" style of beer has somewhat of a curved arguably non-linear relationship.
The majority of values in which ABV is greater than 6% appear to be of an equal distribution about the y-axis, and lose their visual power to explain the variance of IBU ratings.


# KNN - Investigate the Difference With Respect to IBU and ABV Between IPAs and Other Ales

We found with our model that it is possible to predict whether a beer is considered an IPA or Ale based on its IBU and ABV values at an Accuracy of 99.66102%.
The model created to do this is a KNN model which uses neighboring values of a "k"
amount around the given input to predict what the classification of the item in question is.
![image](https://user-images.githubusercontent.com/81498617/197312056-e7197788-2232-4cc2-ba85-8ec70b96e612.png)
