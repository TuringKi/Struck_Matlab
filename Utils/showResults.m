%% showResults: function description
function [out_figs] = showResults(figs, im_o, bb, frame)
    global opt
    global model
	rect_position = [bb([1 2]) - bb([3 4])/2 ,bb([3 4])];
    out_figs = figs;
    tmplsize = opt.tmplsize;
	if isempty(out_figs)
		
       
        if opt.SHOW_APPEARANCES  == 1 && opt.DEBUG == 1
            
            w0 = tmplsize(1);
            h0 = tmplsize(2);
            im_extend = zeros(w0* 10, h0* 10,size(im_o, 3));
           
            count = 1;
            
            [~, idxs] = sort([model.svs.w],'descend');
            
            for i = 1:10
                for j = 1:10
                    %imshow(uint8(model.svs(count).img), [])
                     im_extend((i - 1)*w0 + 1 : i*w0,(j - 1)*h0 + 1 : j*h0,:) = model.svs(idxs(count)).img;
                     count = count + 1;
                     if count > length(model.svs)
                        break;
                     end
                end
                if count > length(model.svs)
                    break;
                end
            end
            out_figs.fig_app_handle = figure('Number','off', 'Name',['Appearances']);
             set(gcf,'DoubleBuffer','on','MenuBar','none');
            out_figs.app_handle = imshow(uint8(im_extend), 'Border','tight', 'initialmagnification','fit');
            
            
        end
            out_figs.fig_handle = figure('Number','off', 'Name',['Tracker']);
            set(gcf,'DoubleBuffer','on','MenuBar','none');
            out_figs.im_handle = imshow(im_o, 'Border','tight','initialmagnification','fit');
            out_figs.rect_handle = rectangle('Position',rect_position, 'EdgeColor','g', 'LineWidth',5);
            out_figs.frame_handle = text(20,20,num2str(frame),'Color','b', 'FontSize',14);
        
        
        
        
    else
        
        if opt.SHOW_APPEARANCES  == 1 && opt.DEBUG == 1
            
            w0 = tmplsize(1);
            h0 = tmplsize(2);
            im_extend = zeros(w0* 10, h0* 10,size(im_o, 3));
           
            count = 1;
            
            [~, idxs] = sort([model.svs.w],'descend');
            
            for i = 1:10
                for j = 1:10
                    %imshow(uint8(model.svs(count).img), [])
                     im_extend((i - 1)*w0 + 1 : i*w0,(j - 1)*h0 + 1 : j*h0,:) = model.svs(idxs(count)).img;
                     count = count + 1;
                     if count > length(model.svs)
                        break;
                     end
                end
                if count > length(model.svs)
                    break;
                end
            end
            set(out_figs.app_handle, 'CData', uint8(im_extend));
        end
        
        
        
		set(out_figs.im_handle, 'CData', im_o);
        set(out_figs.frame_handle,'String',num2str(frame));
		set(out_figs.rect_handle, 'Position', rect_position);
	end
	drawnow
end
