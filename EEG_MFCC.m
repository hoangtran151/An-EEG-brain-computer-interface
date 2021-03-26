num_samples = 14;
length_of_sample = 8193;
samples = zeros(14,length_of_sample);

% get eyes open samples
for o = 1:num_samples/2
    s1 = {'samples/O'};
    s2 = string(o);
    s3 = strcat(s1,s2);
    s4 = {'_1476.TXT'};
    s = strcat(s3,s4);
    samples(o,:) = dlmread(s);
end

% get eyes closed samples
for j = 1:num_samples/2
    s1 = {'samples/C'};
    s2 = string(j);
    s3 = strcat(s1,s2);
    s4 = {'_1476.TXT'};
    s = strcat(s3,s4);
    samples(o+j,:) = dlmread(s);
end

% truncate last column
samples(:,end) = [];

num_filters = 14; % number of filters in bank
filter_width = 4; % 4Hz wide filters
first_frequency = 0; % lambda1
mac_array = zeros(num_samples,num_filters); % multiply accumulate array for each 
y_array = zeros(14,512);

for p = 1:num_samples
    X = samples(p,:);
    X_truncated = X(1:512); % truncate to 512 samples
    Y = (abs(fft(X_truncated))).^2; % absolute value of fft squared
    y_array(p,:) = Y;
end

for d = 1: num_samples
    p = 0;
    for v = 1:num_filters
        f_range = p+1:p+4;
        mac_array(d,v) = sum(interp1(f_range, y_array(d,f_range),f_range));
        p = p + 2;
    end
end


% visualize data
for s = 1:num_samples
    f = 1:14;
    hold on
    if s>= num_samples/2
        plot(f,mac_array(s,f),'color', 'blue'); 
    else 
        plot(f,mac_array(s,f),'color', 'red'); 
    end
end



%{
% plot fft for all samples
for q = 1:num_samples
    Fs= 1476;
    L = 512;
    P2 = y_array(q,:);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    hold on
    if q>= num_samples/2
        plot(f,P1,'color', 'blue'); 
    else 
        plot(f,P1,'color', 'red'); 
    end
end
hold off
%}

