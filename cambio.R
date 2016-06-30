cambio<-function(train){
  train$Rating[(train$Rating>=0)&(train$Rating<=10)] <- 1
  train$Rating[(train$Rating>10)&(train$Rating<=20)] <- 2
  train$Rating[(train$Rating>20)&(train$Rating<=30)] <- 3
  train$Rating[(train$Rating>30)&(train$Rating<=40)] <- 4
  train$Rating[(train$Rating>40)&(train$Rating<=50)] <- 5
  train$Rating[(train$Rating>50)&(train$Rating<=60)] <- 6
  train$Rating[(train$Rating>60)&(train$Rating<=70)] <- 7
  train$Rating[(train$Rating>70)&(train$Rating<=80)] <- 8
  train$Rating[(train$Rating>80)&(train$Rating<=90)] <- 9
  train$Rating[(train$Rating>90)&(train$Rating<=100)] <- 10
  return(train)
}
