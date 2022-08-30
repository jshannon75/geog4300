#Dice roll code

dice_roll<-function(){
  sum(sample(1:6, size = 2, replace = TRUE))
}

results<-replicate(2000,dice_roll())
mean(results)
sd(results)

hist(results)

dice_roll_mean<-function(){
  mean(replicate(20,dice_roll()))
}

results1<-replicate(200,dice_roll_mean())
mean(results1)
sd(results1)

hist(results1)
