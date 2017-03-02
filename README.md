# ConvNet-Voice-Activity
Voice Activity Detection using ConvNet

Convolutional Neural Network (CNN) is a branch of supervised machine learning, used for both classification and regression problem. CNN is widely used in image recognition and voice recognition problems. It has neurons which contain weights and biases. Input is multiplied with weights followed by bias addition to get output. These output are then followed by non-linearity function. Each neuron here are called nodes, each layer will have multiple nodes. Last layer will give us the score, which is input to softmax layer. Softmax layer converts score to probability. At output layer we can use cross entropy technique to find the label.  


In this project CNN classifies image inputs as signal+noise or noise. Input to architecture is row major image and output is the label (1 for signal+noise, 2 for noise). Architecture of CNN contains many layers called hidden layers, between input and the output. Each hidden layer is either convolution layer, pooling layer or activation function (discussed in detail later)

Please use MatConvNet library, for running this file. 
