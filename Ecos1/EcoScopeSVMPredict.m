function [test_error,predicted_test_labels] = EcoScopeSVMPredict(data,SVMmodel)

%labels = ones(size(data,1),1);

%% pre-scaling: mean & var
% minimums = min(data, [], 1);
% ranges = max(data, [], 1) - minimums;
%
% data = (data - repmat(minimums, size(data, 1), 1)) ./ repmat(ranges, size(data, 1), 1);

healthyMean = SVMmodel.mean;
healthyStd = SVMmodel.std;
model = SVMmodel.model;

data = (data - repmat(healthyMean, size(data, 1), 1)) ./ repmat(healthyStd, size(data, 1), 1);

%%


test_label = ones(size(data,1),1);

[predicted_test_labels] = svmpredict(test_label, data, model,'-q');


%train_error = length(find(predicted_train_labels ~=train_label))/length(train_label); % 98.87%
test_error = length(find(predicted_test_labels ==test_label))/length(test_label)*100; % 98.6%

% h=figure('Visible','off');
% subplot(2,1,1);
% plot(predicted_test_labels);
% ylim([-1.1 1.1]);
% title(['SVM Result of ', FigFileName]);
% xlabel('Time');
% 
% Output = (predicted_test_labels+1)/2+1;
% fisherScore = fsFisher(data, Output);
% normScore = fisherScore.W./sum(fisherScore.W)*100;
% 
% subplot(2,1,2)
% barh(normScore(fisherScore.fList(3:-1:1)));
% x = normScore(fisherScore.fList(3:-1:1))';
% labels=channelName(fisherScore.fList(3:-1:1));
% set(gca,'YTick',1:3,'YTickLabel',labels);
% xlabel('Percent (%)');
% if(~isnan(max(x)))
%     xlim([0 round(max(x)*1.2)]);
% end
% text(x,(1:3),num2str(floor(x)));
% 
% outputFilename = strcat(fileName,'_SVM_', num2str(floor(test_error)),'.jpg');

%print(h, '-djpeg', outputFilename);


