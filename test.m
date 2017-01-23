%script is used for testing the CNN model over all the data batches and
%over all the SNR folders%script fecthes the best validation epoch 
%(which has minimum error) and runs it on testing data.
%stores the value of confusion matrix, accuracy for each iteration.
%This runs for 15 iterations (5 in each of 3 SNR) and takes average over
%all 15 data_bacthes. Reports the accuracy, confusion matrix and time taken
%for each image. 

%initialising variables to zeros (in their shape) for MATLAB faster
%execution
clear all; close all;
conf_mat = zeros(2,2,5);
accuracy = zeros(1,5);
average_accuracy = zeros(1,3);
average_confusion_mat = zeros(2,2,3);


%tic;
%All SNR values
data_select = [0,5,10]; %Please select the data to run the test
Number_Of_data_batches = 5; %Select 1 just to run data_batch_1.mat, 
%2 for both, 3,4 and 5 respectively to run all 3, 4 and 5 data batches
for ii = 1:numel(data_select)
    SNR_value = sprintf('SNR_%d',data_select(ii));
    for test_epoch = 1:Number_Of_data_batches
        %selecting the epoch used for testing
        epoch_value = sprintf('net-epoch-%d_test.mat',test_epoch); 
        path = fullfile(vl_rootnn, 'examples\testing\', SNR_value,'\',epoch_value);
        var = load(path);
        %selecting data to test on
        batch_value = sprintf('data_batch_%d.mat',test_epoch);
        dataDir = fullfile(vl_rootnn, 'data\SNR\', SNR_value,'\', batch_value);
        fd = load(dataDir) ;
        
        %reshape the data for algorithm to understand
        data = single(permute(reshape(fd.data',40,40,1,[]),[2 1 3 4])) ;
        %reshape labels
        labels  = fd.labels';
        
        %adding softmax layer which convert score to probability 
        var.net.layers{end}.type = 'softmax';
        
        %calling testing function, simplenn file runs over the ConvNet
        %architecture to give final predicted values
        tic;
        res = vl_simplenn(var.net, data(:,:,:,:),[]);
        %calculating time for each image
        time_for_one_batch = toc;
        time_for_each_image(test_epoch) = time_for_one_batch/size(data,4);
        %res is values at each layer, hence fetching value at last layer.
        %res(end), x is the probability calculated
        temp = (res(end).x);
        
        %gather the values of probability of each class predicted
        val_class1 = gather(temp(:,:,1,:));
        val_class2 = gather(temp(:,:,2,:));
        
        %put them in 2xno of samples format
        g = squeeze([val_class1 val_class2]);
        %get the max of two probability, to determine class, class 1 for
        %signal, 2 for noise
        [~,pred] = max(g);
        %Get confusion matrix
        conf_mat(:,:,test_epoch) = confusionmat(labels',pred');
        %confMatPlot(A);
        %calculate accuracy for each iteration
        accuracy(test_epoch) = (conf_mat(1,1,test_epoch)+conf_mat(2,2,test_epoch))...
            /sum(conf_mat(:,1,test_epoch)+conf_mat(:,2,test_epoch));
    end
    
    %calculate accuracy and confusion matrix for all 5 batches. 
    average_accuracy(ii) = mean(accuracy);
    average_confusion_mat(:,:,ii) = mean(conf_mat,3);
    time_for_each_image_each_snr(ii) = mean(time_for_each_image);
end

%calculate average of all 15 data batches, and display them
%displaying the memory consumption
fprintf('parameter memory|481KB (1.2e+05 parameters)| \n')
%displaying time for each image
avg_time = mean(time_for_each_image_each_snr);
fprintf('average time for each image = %d \n', avg_time);
%displaying the total average accuracy
total_average_accuracy = 100*mean(average_accuracy);
fprintf (['accuracy = ', num2str(total_average_accuracy)], '\n' );
final_conf_mat = mean(average_confusion_mat,3)
%fprintf ('final_conf_mat = %d', final_conf_mat );


%toc;