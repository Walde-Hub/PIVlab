function laser_device_id = find_laser_device
%handles=gui.gethand;
gui.put('sync_type',[]); %remove any eexpectation about connected synchronizer
serpo=gui.retr('serpo');
try
	serpo.Port;
	alreadyconnected=1;
catch
	alreadyconnected=0;
end
if alreadyconnected

	if exist('laser_device_id.mat','file') == 2
		old_laser_device_id = load('laser_device_id.mat','id');
		old_laser_device_id = old_laser_device_id.id;
	else
		old_laser_device_id='%';
	end
	string1='WhoAreYou?';
	string2='WhichFirmWare?';
	string3='WarningSignEnable!';

	try
		writeline(serpo,string1);
		pause(0.3)
		warning off
		serial_answer=readline(serpo);
		disp(['Connected to: ' convertStringsToChars(serial_answer)])
		if contains(serial_answer,'oltSync:') %decide which synchronizer hardware is connected
			gui.put('sync_type','oltSync') %Waldemars Sync
			disp('oltSync detected')
		else
			if ~isempty(serial_answer)
				gui.put('sync_type','xmSync') %Williams Sync
				disp('xmSync detected')
			end
		end
		warning on
	catch
		disp('Error sending WhoAreYou')
	end
	try
		writeline(serpo,string2);
		pause(0.3)
		warning off
		firmware_version=readline(serpo);
		warning on
		if isempty(firmware_version)
			firmware_version='pre feb 22';
		else
			firmware_version=convertStringsToChars(firmware_version);
			if contains(firmware_version,'oltSync:')
				firmware_version = firmware_version(strfind(firmware_version,'oltSync:')+8 : end);
			end
		end
		disp(['Firmware: ' firmware_version])

		delete(findobj('tag','laser_info_box'));
		try
			Kinder=get(gca,'Children');
			for k=1:size(Kinder,1)
				if isprop(Kinder(k),'CData')
					img_size=size(Kinder(k).CData,1);
					break
				end
			end
			text(10,img_size*0.95,['Connected to:  ' convertStringsToChars(serial_answer) sprintf('\n') 'Firmware:  ' convertStringsToChars(firmware_version)],'tag','laser_info_box','Color','black','BackgroundColor','green','VerticalAlignment','bottom','interpreter','none');
		catch
		end
	catch
		disp('Error sending WhichFirmware')
	end
	try
		pause(0.3)
		writeline(serpo,string3); %enable the lighting of the laser warning sign
	catch
		disp('Could not enable Laser warning sign')
	end
	%%debug messages
	%{
disp('---------')
	disp(['Port is: ' serpo.Port])
	disp(['Terminator set to: ' serpo.Terminator])
	disp(['String written: ' string1])
	disp(['String written: ' string2])
	disp(['Answer: ' convertStringsToChars(serial_answer)])
disp('---------')
	%}

	if isempty(serial_answer)
		uiwait(msgbox(['No laser found.' sprintf('\n') 'Is the laser turned on?' sprintf('\n') 'Please try again.'],'modal'))
	end
	if strncmp(old_laser_device_id,serial_answer,20)==0 %if last laser ID DOES NOT equal current laser ID
		get_laser_id = inputdlg(['Please enter the ID of your laser / synchronizer.' sprintf('\n') 'It can be found on the sticker on the device.' sprintf('\n') 'Firmware: ' convertStringsToChars(firmware_version)],'First time connection',1,{convertStringsToChars(serial_answer)});
		if ~isempty(get_laser_id)
			id=get_laser_id{1};
			filepath = fileparts(which('PIVlab_GUI.m'));
			save (fullfile(filepath, 'PIVlab_capture_resources', 'laser_device_id.mat'),'id')
		end
	end
	laser_device_id = load('laser_device_id.mat','id');
	laser_device_id = laser_device_id.id;
else
	acquisition.no_dongle_msgbox
end

