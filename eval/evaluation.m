function [ results,metricList ] = evaluation( Ypre,Yout,Yte,time,flagRC )
%EVALUATION Evaluation of a multi-view multi-task method
%
%      Input:
%
%          Ypred          1 x T predicted label cell         
%          Yout           1 x T outputed label cell           
%          Yte            1 x T groundtruth label cell
%
%      Output:
%          results
%            results(1)             Root Mean Squared Error (RMSE)
%            results(2)             Mean Absolute Error (MAE)
%          metricList               List of used evaluation metrics

if flagRC   % Classification task
    results = zeros(5,1);
    results(1) = time;
    results(2) = evalAUC(Yout,Yte);
    results(3) = evalAccuracy(Ypre,Yte);
    results(4) = evalMacroF1(Ypre,Yte);
    results(5) = evalMicroF1(Ypre,Yte);
    metricList = 'Time AUC Accuracy MacroF1 MicroF1';
else        % Regression task
    results = zeros(3,1);
    results(1) = time;
    results(2) = evalRMSE(Yout,Yte);
    results(3) = evalMAE(Yout,Yte);
    metricList = 'Time RMSE MAE';
end

end

