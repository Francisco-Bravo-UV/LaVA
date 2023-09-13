%% OPEN OSCILLOSCOPE INSTEK
clear all, close all, clc
delete(instrfindall)

GDS2104E = serial('COM11','BaudRate',115200,'Timeout',15,'InputBufferSize',10e6);    % Create serial port object.
fopen(GDS2104E);
disp(query(GDS2104E, '*IDN?'));  % Display instrument identification.
fprintf(GDS2104E, '*CLS');       % Clear error queue.
%%
CountIn = 0;        % Input signal counter.
CountOut = 0;       % Output signal counter.
%%

frec= 30:10:1000;
for i=1:length(frec)
% frec(i)
% FF=48000;
% t=0:1/FF:3;
% 
% y=sin(2*pi*frec(i)*t);
% %plot(t,y)
% sound(y,FF);
% pause(2)

    % Clear serial input buffer.
if GDS2104E.BytesAvailable > 0
    flushinput(GDS2104E)
end
    CountIn=CountIn+1;
ChIn = 1;    % Select channel to aquire (1, 2, 3, 4).

% CountIn = CountIn + 1;                                  % Counter to save the input signals in different columns.

 while (GDS2104E.bytesAvailable < 20536)
        % Clear input buffer if other data is available.
        flushinput(GDS2104E)                                                       
        fprintf(GDS2104E, [':ACQ' num2str(ChIn) ':MEM?'] );    % Start acquiring short (:MEM?) or long (:LMEM?) memory.
        pause(0.2)
 end
AcqHeader = strrep(fscanf(GDS2104E,'%c'),',',';');      % Read the oscilloscope's acquiring configuration (Header).
fread(GDS2104E,1,'char');                               % Read the # at the start of the binblock raw data.
AcqBytes = str2double(char(fread(GDS2104E,1,'char')));  % Read the number of digits of the byte size of the binblock.
AcqPts = fix(str2double(char(fread(GDS2104E,AcqBytes,'int8')))/2);  % Read the number of data bytes that the binblock will contain.

[Input_Waveform_Data] = Waveform_Parameters(AcqHeader);     % Organize the Header information.

% Read the acquired data and convert it from 16bit integer to voltage.
Input(:,CountIn) = fread(GDS2104E,AcqPts,'int16')*Input_Waveform_Data.Vertical_Scale_Div*(10.0/65535);
Time_Input(:,CountIn) = linspace(0, length(Input)*(1/Input_Waveform_Data.Sample_Frec), length(Input))'; % Build acquisition time vector.

  DataPlot = figure(1);
  DataPlot.Color = 'w';
  plot(Time_Input(:,CountIn)*1e3,Input(:,CountIn),'.-'), grid minor
  set(gca,'fontsize')
  title('Input Signal')
  xlabel('Time [ms]')
  ylabel('Voltage [V]')

% Clear input buffer if other data is available.
flushinput(GDS2104E)

%   DataPlot = figure(1);
%   DataPlot.Color = 'w';
%   plot(Time_Input(:,CountIn)*1e3,Input(:,CountIn),'.-'), grid minor
%   set(gca,'fontsize')
%   title('Input Signal')
%   xlabel('Time [ms]')
%   ylabel('Voltage [V]')
 
  drawnow
  disp('Listo para captura?')
  pause()
  i=i+1;
end
%    clear Input Time_Input Output2 Time2 Output3 Time3 Output4 Time4
%%
save('prueba_resonador_con_cuello_largo_52cm_del_parlante.mat','Input','Time_Input');
%%
fclose(GDS2104E);