# Short-term-predictor
The goal of this project is to define a model for the short-term forecast of the time series data corresponding to Wednesday, based on the previous seven days(from the previous Wednesday to Tuesday).
In particular, to write a Matlab function that takes as input a vector of seven values ​​(from Wednesday to Tuesday) and that returns the prediction of the next day.
The data used are data about gas prices of two consecutive years and we dived them in the first year for training of model and second year for the validation.

*Data visualized*
![visual data](https://user-images.githubusercontent.com/48360582/169085326-d6c38e73-ddbb-4b5c-94cd-2b3467b423f8.jpg)


*Mean values for weeks and only Wednesday*
![Means](https://user-images.githubusercontent.com/48360582/169085733-b825ab74-b74f-4785-85dc-21951afa3c5f.jpg)


We used different model for instance a simple linear model than second order one and also we tried with a neural network not useful this case.
These models were compared using different metrics; To evaluate models we used Crossvalidation(SSR), FPE and AIC.

*linear model*
![primo ordine](https://user-images.githubusercontent.com/48360582/169086944-b9612e74-c932-4764-82d2-66e61f475b4a.jpg)


*second order model*
![Secondo ordine](https://user-images.githubusercontent.com/48360582/169086980-def957d0-2bff-4bcf-b282-77f9d63c0f9f.jpg)


At the end the best was a simple linear model that does not use values of saturday and sunday that were considered as outliers in fact they are completly different and outscale with respect to ones of the week.
