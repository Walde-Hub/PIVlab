function draw_line_Callback(~, ~, ~)
filepath=gui.retr('filepath');
caliimg=gui.retr('caliimg');
if numel(caliimg)==0 && size(filepath,1) >1
	gui.sliderdisp(gui.retr('pivlab_axis'))
end
if size(filepath,1) >1 || numel(caliimg)>0 || gui.retr('video_selection_done') == 1
	handles=gui.gethand;
	gui.toolsavailable(0)
	delete(findobj('tag', 'caliline'))
	roi = images.roi.Line;
	%roi.EdgeAlpha=0.75;
	roi.LabelVisible = 'on';
	roi.Tag = 'caliline';
	roi.Color = 'y';
	roi.StripeColor = 'g';
	roi.LineWidth = roi.LineWidth*2;
	Cali_coords = gui.retr('pointscali');
	if ~isempty(Cali_coords)
		roi=drawline(gui.retr('pivlab_axis'),'Position',Cali_coords);
		%roi.EdgeAlpha=0.75;
		roi.LabelVisible = 'on';
		roi.Tag = 'caliline';
		original_linewidth=roi.LineWidth;
		roi.LineWidth = original_linewidth*2;
		for rep=1:2 %bring users attention to already existing line
			roi.Color = 'g'; roi.StripeColor = 'y';
			pause(0.1)
			roi.Color = 'y'; roi.StripeColor = 'g';
			pause(0.1)
		end
		roi.Color = 'y';
		roi.StripeColor = 'g';
		roi.LineWidth = original_linewidth*2;
		pause(0.1)
	else
		axes(gui.retr('pivlab_axis'))
		draw(roi);
	end
	addlistener(roi,'MovingROI',@calibrate.Calibrationevents);
	addlistener(roi,'DeletingROI',@calibrate.Calibrationevents);

	dummyevt.EventName = 'MovingROI';
	calibrate.Calibrationevents(roi,dummyevt); %run the moving event once to update displayed length
	gui.toolsavailable(1)
end

