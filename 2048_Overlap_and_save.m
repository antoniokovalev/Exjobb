prompt = 'Enter the size of input: ';
x_size = input(prompt); % Multiple of 1024
%prompt = 'Ange antalet nya sampel in i 2048-FFT:n varje iteration: ';
%in = input(prompt);
in = 1024;
gamla = 2048-in;
x = transpose(rand(x_size, 1)); 
h = transpose(rand(1024, 1)); % Filter impulse response length M = 1024.

h_padded = [h transpose(zeros(1024,1))]; % Padded with zeros, so that 
                                % mult. in fdded with zeros, so that 
                                % mult. in frequency will be ok.
                                
% 2048-FFT.
H1 = fft(h_padded);           

%in = 10;
%gamla = 2038;

number_of_blocks = (x_size/1024);
x_new_1 = x(1:1024);
x_old_1 = transpose(zeros(1024,1));
x_new_2 = transpose(zeros(1024,1)); %x(1025:2048);
x_old_2 = x_new_1;
switch_fft = 1;

for n = 1:number_of_blocks
    
    if n ~=1
        if switch_fft == 1
            x_new_1 = x((n-1)*1024+1 : (n)*1024);
            x_old_2 = x_new_1;
        else
            x_new_2 = x((n-1)*1024+1 : n*1024);
            x_old_1 = x_new_2;
        end
    end
     
     
     x_after_fft1 = fft([x_new_1 x_old_1]);
     x_after_fft2 = fft([x_new_2 x_old_2]);
     
     
     output_1 = ifft(x_after_fft1.*H1);
     
     output_2 = ifft(x_after_fft2.*H1);
     
     if n == 1
		output = [output_1(1:1024)];   
     % Ta ut 1024 sampel från FFT1
     elseif switch_fft == 1
		output = [output output_1(1:1024)];
     % Ta ut 1024 sampel från FFT2
     elseif switch_fft == 2
		output = [output output_2(1:1024)];       
         end
     
     if switch_fft == 1
         switch_fft = 2;
     else
         switch_fft = 1;
     end
     length(output);
     
end
length(output)
falt = conv(x,h);
length(falt)
%stem(output)
%hold on;stem(falt)