classdef SupportPattern < handle
	properties
		X;
        Y;
        ref;
        imgs;
	end
	
	methods
		function obj = SupportPattern(X, Y, ref_count, imgs)
			obj.X = X;
            obj.Y = Y;
            obj.ref = ref_count;
            obj.imgs = imgs;
		end
	end
end