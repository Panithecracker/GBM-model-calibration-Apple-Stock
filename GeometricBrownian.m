%First, lets import the data from apple stock closing prices from past 6
%months :
clear all
stockData = readtable('AppleStockData.csv','PreserveVariableNames',true);
dates = flip(stockData.Date);
closes = flip(stockData.Close);
LogRatios = diff(log(closes));
%just to see how much the actual returns differ from the log ratios above
%they are pretty much the same 
for i =1:250
    relativeChanges(i,1) = (closes(i+1,1)-closes(i,1))/(closes(i,1));
end
% Plot observed stock path
plot(linspace(0,1,253), [closes(1,1) closes' closes(251,1)], 'b');  % Plot the data in blue
title('Apple Stock Data');
xlabel('Months');
ylabel('Closing Price');
grid on;
% Set the tick positions at every 21 trading days or a month
xticks(0:21/252:1);  % Tick positions every 21 trading days
xticklabels(0:12);  % Label ticks as 1, 2, 3, ...
hold on;

%% calibrating the model : estimating annual drift and volatility

%assuming that the price moves according to GBM :
%estimating the annualized drift and volatility of the stock
pd = fitdist(LogRatios,'Normal');
drift = 252*(0.5*(pd.sigma^2)+pd.mu);
volatility = sqrt(252)*pd.sigma;
%Euler Maruyama to simulate different trajectories:
%the governing equation is ds/s = udt+sigdW
dt = 1/252;
sample_size = 5;
T = 3/12; %3 months (on average 21 trades per month)
Times = linspace(0,T,(T/dt)+1);
S(1,1) = closes(1,1); %start with the starting price lets see if we get similar trajectories to the observed on
path_h = plot([0],[closes(1,1)],'red'); %handler for the 'active' path
particle_h = scatter(0,closes(1,1),'red','filled'); %point particle handler
syms f(t) t
f(t) = closes(1,1)*exp(drift*t); %expected trajectory
fplot(f(t),[0,1]);
hold on
for s =1:sample_size
    %compute a possible path with Euler
    for i=1:ceil(T/dt)
        S(i+1,1) = S(i,1)+(drift*dt+volatility*sqrt(dt)*normrnd(0,1))*S(i,1);
        %update the plots dynamically
%         set(particle_h,'Xdata',i*dt);
%         set(particle_h,'Ydata',S(i+1,1));
%         set(path_h,'Xdata',Times(1,1:i+1));
%         set(path_h,'Ydata',S(1:i+1,1));
%         drawnow();
    %% take the final price after T years
    expiry(s,1) = S(size(S,1),1); 
    end
    plot(Times',S,'Color', [1, 0, 0, 0.4]);
% plot(Times',S);
end

 
% %% obtaining the histogram by sampling from the exact solution instead
% for s =1:sample_size
%    %just observe from the rv :  closes(1,1)*exp((drift-0.5*volatility^2)*T+volatility*sqrt(dt)*normrnd(0,1))
%    Exact(s) = closes(1,1)*exp((drift-0.5*volatility^2)*T+volatility*sqrt(T)*normrnd(0,1));
% end
% figure
% hist(Exact); 
% title(sprintf("Price distribution after %.0f months", 12 * T));
% h = findobj(gca,'Type','patch');
% h.FaceColor = [0 0.5 0.5];
% h.EdgeColor = 'w';
% % Add vertical lines to separate regions
% xline(closes(1,1), 'LineWidth', 3, 'Color', 'white'); % Reference price line
% xline(2/3*closes(1,1), 'LineWidth', 3, 'Color', 'red'); % Loss margin
% xline(3/2*closes(1,1), 'LineWidth', 3, 'Color', 'green'); % Winning margin
% p1 = sum(Exact >= 1.5*closes(1,1))/(sample_size); %probability of having a return higher than 50%
% p2 = sum(Exact <= (2/3)*closes(1,1))/(sample_size); %probability of having a negative return of more than 33%
% 
% %% using the exact solution to find the probabilities for arbitrary times, in particular for every 1/2 months
% figure 
% for m=1:24
%     for s=1:sample_size
%         Price(s,1) = closes(1,1)*exp((drift-0.5*volatility^2)*(m/24)+volatility*sqrt(m/24)*normrnd(0,1));
%     end
%     MonthlyChances(m,1) = (sum(Price >= 1.5*closes(1,1)))/(sample_size);
% end
% plot([1/24:1/24:1],MonthlyChances,'*--');
% grid on;
% title("Probability of having returns greater than 50%");
% xlabel("Months");
% ylabel("Probability");
% xticks(1/12:1/12:1);  % Tick positions every 21 trading days
% xticklabels(1:12);  % Label ticks as 1, 2, 3, ...
% 