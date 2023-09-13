function [Waveform_Data] = Waveform_Parameters(AcqHeader)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
AcqHeaderCell = textscan(AcqHeader,'%s', 'HeaderLines',0,'Delimiter',';');
Header = char(AcqHeaderCell{1,1});
Waveform_Data.Trigger_Level = str2double(Header(10,:));
Waveform_Data.Channel = Header(12,:);
Waveform_Data.Vertical_Units = Header(14,:);
Waveform_Data.Probe_Attenuation = str2double(Header(24,:));
Waveform_Data.Vertical_Scale_Div = str2double(Header(26,:));
Waveform_Data.Vertical_Position = str2double(Header(28,:));
Waveform_Data.Horizontal_Units = Header(30,:);
Waveform_Data.Horizontal_Scale_Div = str2double(Header(32,:));
Waveform_Data.Horizontal_Position = str2double(Header(34,:));
Waveform_Data.Sample_Frec = 1/str2double(Header(40,:));
Waveform_Data.Time_acqu_Waveform_Data = Header(48,:);
end

