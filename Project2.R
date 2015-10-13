rm(list = ls());
library(jpeg);
library(caret);
library(nnet);

# use color average for feature vector (for reference)
colorAveraging <- function(img, r1, c1, r2, c2){
  retVal <- c();
  r = 0.0; g = 0.0; b = 0.0;
  a = (r2 - r1 + 1) * (c2 - c1 + 1);
  for (i in r1: r2){
    for (j in c1: c2){
      r <- r + img[i, j, 1] * 255;
      g <- g + img[i, j, 2] * 255;
      b <- b + img[i, j, 3] * 255;
    }
  }
  retVal <- c(retVal, c(r / a, g / a, b / a));
  return(retVal);
}

# load images
files <- list.files("./mit8-images-64x64", full.name = TRUE);

# init dataset (data loaded from pre-generated .CSV)
dataset <- read.table(file="data.csv", header=TRUE, sep=",");
dataset <- as.data.frame(dataset);

# separate dataset into training set/testing set 
partition <- createDataPartition(dataset$category, p = 0.7, list = FALSE);
trainingSet <- dataset[partition, ];
testingSet <-dataset[-partition, ];

set.seed(21);

# relabel
for (i in  1 : ncol(trainingSet) - 1) {
  colnames(trainingSet)[i] <- i;
  colnames(testingSet)[i] <- i;
}

# generate output file
toHTML <- function(setName, result, expected, fileList, index = NULL) {
  category <- c("coast", "forest", "highway", "insidecity", "mountain", "opencountry", "street", "tallbuilding");
  err <- abs(result != expected);
  result <- as.data.frame(unclass(t(result)));
  expected <- as.data.frame((unclass(t(expected))));
  
  sink(file = "./output.html", append = TRUE, type = "output");
  
  cat("<h1>", setName ,"error: ", sum(err) * 100.0/ncol(result), "%<h1><br>");
  cat("<style>
      .cell { display:inline-block; border: solid 1px #aeaeae; padding: 5px; margin: 3px; border-radius: 3px; background-color: lavender; }
      .small { width:64px; }
      .tag { color: red; }
      </style>");
  
  for (j in 1 : ncol(result)) {
    for (i in 1: length(category)){
      if (result[j] == i) {
        cat("<div class=cell>");
        imgIndex = as.numeric(index[j]);
        
        if (result[j] == expected[j]){
          cat ("<img class=small src=", fileList[imgIndex], ">");
        } else {
          cat ("<img src=", fileList[imgIndex], ">");
        }
        cat("<br><span class=tag><font size=3>", category[i], "</font></span></div>");
        break;
      }
    }
  }
  cat("<hr>\n");
  sink(file = NULL, type = "output");
}

# logistic regression
logisticRegression <- function(trainingSet, testingSet, fileList) {
  index <- rownames(trainingSet);
  x <- subset(trainingSet, select=-c(category));
  y <- trainingSet[, "category"];
  M <- multinom(y ~ data.matrix(x), data = trainingSet);
  
  y1 <- predict (M, newdata = trainingSet); 
  err <- abs(y1 != y);
  trainError <- sum(err)/nrow(trainingSet);
  toHTML("Training", y1, y, fileList, index);
  
  index <- rownames(testingSet);
  x <- subset(testingSet, select=-c(category));
  y <- testingSet[, "category"]; 
  
  y1 <- predict (M, data.matrix(x)); 
  err <- abs(y1 != y);
  testError <- sum(err)/nrow(testingSet);
  toHTML("Testing", y1, y, fileList, index);
  
  return(c(trainError, testError));
}

# calculate error
error <- rbind(c(logisticRegression(trainingSet, testingSet, files)));

# export error to .CSV
write.csv(error, "error.csv");