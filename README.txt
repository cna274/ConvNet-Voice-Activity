Detecting Speech Activity Using Convolutional Neural Network (CNN) Classifier 

Please use matconvnet-1.0 version-23 to run the file.
create 'data' folder
Inside data folder create 'SNR' and add all the data (SNR_0, 5 and 10)

Add SNR folder (contains cnn_speech.m, cnn_speech_init.m, test.m) provided to ~\Documents\MATLAB\matconvnet-1.0-beta23\examples

To Train :

1. Run cnn_speech.m.
2. Currently set to train using SNR_10 using [3,4,5] for training and 1 for validation and you can use 2 to test
3. For user to train, validate and test on data batch of his choice.
3. Change variable SNR (at line 96) to either 0 or 5, training_data (at line 98) to any three of [1,2,3,4,5], validation_data variable to any one of [1,2,3,4,5]. remaining data batch can be used for testing later.


To Test:

1. Run test.m
2. It takes around 15 mins to run through all the 5 data batches (cross-validation) and all three SNR folders
3. Please change data_select variable to run the selected SNR (line number 20 in test.m)
4. Please change Number_Of_data_batches variable to run the selected data_batch in each variable (line number 25 in test.m)
