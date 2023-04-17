%function which finds the value of the longest # of hours spent
%consecutively above 'criticalpyridine' level.
function f = findlength(A, criticalpyridine)

B = A(1:end)> criticalpyridine; %creates logical array of I > criticalpyridine

result=reshape(find(diff([0;B;0])~=0),2,[]); %wraps the array with 0s each end, finds the difference and reshapes

[length,position]=max(diff(result)); %records maximum consecutive string of 1s, and position

start=result(1,position); % where it starts

if length > 0
   f = length; % length of the longest sequence of 1s 
else f = 0; %avoids giving NaN value for 0 result
    
end