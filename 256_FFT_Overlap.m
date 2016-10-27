% 256x8 matrix, representing 256 8 tap filters:
clear all
filters = rand(1024,1).';

H1 = [filters(1:128) transpose(zeros(128,1))];
H1_fft = fft(H1);
H2 = [filters(129:256) transpose(zeros(128,1))];
H2_fft = fft(H2);
H3 = [filters(257:384) transpose(zeros(128,1))];
H3_fft = fft(H3);
H4 = [filters(385:512) transpose(zeros(128,1))];
H4_fft = fft(H4);
H5 = [filters(513:640) transpose(zeros(128,1))];
H5_fft = fft(H5);
H6 = [filters(641:768) transpose(zeros(128,1))];
H6_fft = fft(H6);
H7 = [filters(769:896) transpose(zeros(128,1))];
H7_fft = fft(H7);
H8 = [filters(897:1024) transpose(zeros(128,1))];
H8_fft = fft(H8);

filt_in_freq = horzcat(H1_fft.', H2_fft.', H3_fft.', H4_fft.', H5_fft.', H6_fft.', H7_fft.', H8_fft.');

x_in =[rand(7859,1).'];
number_of_blocks = length(x_in)/128;

for j =1:number_of_blocks
    % Stoppa in nollor första gången
   % x_in=[rand(128,1).' zeros(128,1).']
   % x_fft = fft(x_in);
    if j==1
        x_old = transpose(zeros(128,1));
        x_new = x_in(1:128);
        x_fft = fft([x_new x_old]);
        x_old = zeros(128,1).';
        %x_old = x_new;
        %rand(1,1).'
    else
        x_new = x_in((j-1)*128+1 : j*128);
        x_fft = fft([x_new x_old]);
        x_old = zeros(128,1).';
        %x_old = x_new;
    end 
    
    if j == 1
		x_fft_blocks = x_fft;   
    else
		x_fft_blocks = [x_fft_blocks ; x_fft];
    end
   
end    
    
    for n = 1:256
        if n == 1
            filt_sig = conv(x_fft_blocks(:,n).', filt_in_freq(n,:)); % filter, or convolve n:th sample with n:th 8-tap filter.
            x_ifft = [filt_sig];
        else
            filt_sig = conv(x_fft_blocks(:,n).', filt_in_freq(n,:)); % filter, or convolve n:th sample with n:th 8-tap filter.
            x_ifft = [x_ifft; filt_sig];
        end
        size(x_ifft);
    end
    
    for i = 1:length(filt_sig)
        if  i == 1 %%&& j == 1
            output = ifft(x_ifft(:,1));
            output = output(1:256).';
        else
            out = ifft(x_ifft(:,i)).';
            output = [output(1:128*(i-1)) out(1:128)+output(128*(i-1)+1: 128*i)  out(129:256)];
        end
        %a = output(129:256) + output(257:384)
    end

falt = conv(x_in,filters);
disp('Length of output is:');
length(output)
disp('Length of falt is:');
length(falt)
   diff = falt(1:length(output)-1)-output(1:end-1);  
   string = 'The maximum diff between any pair of values: '
   max(abs(diff))
%stem(falt,'r')
%hold on;stem(output,'b')


