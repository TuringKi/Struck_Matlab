function [] = updateModel( im )
    global opt
    global model
    
    bb =est2bb(opt.tmplsize, opt.est);
    region = [1, 1, size(im)]';
    if isempty(model)
      model.sps = [];
      model.svs = [];
      model.m_C = opt.ssvm_mC;
    end
    
    %draw samples
    [samples,XX] = RadialSampler(im, bb', opt.tmplsize, region, 2*opt.radius, 5, 16);
    imgs = [];
    for i = 1 : length(XX)
        X(:, i) = genHoGFeature(XX{i});
        if opt.DEBUG
            imgs{i} = XX{i};
        end
    end
    sp = SupportPattern(X, samples, 0, imgs);
    model.sps = [model.sps;sp];
    
    processNew(length(model.sps));
    BudgetMaintenance();
    
    for i = 1:10

		reprocess();
		BudgetMaintenance();
    end
    
    clearZeroSupportVectors();
end


function [] = clearZeroSupportVectors()
    global model
    i = 1;
    while 1
        if i > length(model.svs) break;end
        sv = model.svs(i);
        if abs(sv.w) < 1e-5
            removeSupportVector(i);
        end
        i = i + 1;
    end
    
end

function [idx] = addSupportVector(sps_idx, sp_idx, g)
    global model
    global opt
    
    sv.x = model.sps(sps_idx).X(:, sp_idx);
    sv.y = model.sps(sps_idx).Y(:, sp_idx);
    sv.idx = sp_idx;
    sv.g = g;
    sv.sp = model.sps(sps_idx);
    sv.w = 0.0;
    
    if opt.DEBUG
        sv.img = model.sps(sps_idx).imgs{sp_idx};
    end
    
    %update the ref count of supportpattern
    model.sps(sps_idx).ref = model.sps(sps_idx).ref + 1;
   
    model.svs = [model.svs;sv];
    
    idx = length(model.svs);
end


function [] = processNew(idx)
    global model
    global opt
    
    idx_p = addSupportVector(idx, 1, evaluate(model.sps(idx).X(:, 1)));
    
    [min_idx, min_g] = MinGradient(idx);
    if opt.DEBUG
        %disp(['processNew: min_idx = ' num2str(min_idx)]);
    end
    idx_n = addSupportVector(idx, min_idx, min_g);
    
    SMOStep(idx_p, idx_n);
end

function [min_idx, min_g] = MinGradient(idx)
    global model
    sp = model.sps(idx);
    min_idx = -1;
    min_g = inf;
    for i = 1:size(sp.X, 2)
        grad = -loss(sp.Y(:, 1), sp.Y(:, i)) - evaluate(sp.X(:, i));
        if(grad < min_g)
            min_idx = i;
            min_g = grad;
        end
    end
end


function [] = SMOStep(idx_p, idx_n)
    global model
    global opt
    if opt.DEBUG
        %disp(['SMOStep: idx_p = ' num2str(idx_p) ', idx_n = '  num2str(idx_n)]);
    end
    if idx_p == idx_n 
        return;
    end
    
   
    
    svs = model.svs;
    sv_p = svs(idx_p);
    sv_n = svs(idx_n);
    
    assert(sv_p.sp == sv_n.sp);
    
    %find the support pattern's features vector.
    %sp_X = model.sps(sv_p.sp).X;
    %sp_x = sp_X(:,1);
    
    if ((sv_p.g - sv_n.g) < 1e-5)
       
    else
        kii = kernel(sv_p.x, sv_p.x) + kernel(sv_n.x, sv_n.x) - 2 * kernel(sv_p.x, sv_n.x);
        lu = (sv_p.g - sv_n.g) / kii;

        l = min(lu, model.m_C*(sv_p.idx == 1) - sv_p.w);
        if opt.DEBUG
            %disp(['SMOStep: l = ' num2str(l)]);
        end
        %uodate the choose positive and negative samples
        model.svs(idx_p).w = sv_p.w + l;
        model.svs(idx_n).w = sv_n.w - l;
        
        %update other support vectors
        for i = 1:length(svs)
            x = svs(i).x;
            model.svs(i).g = model.svs(i).g - l*(kernel(x, sv_p.x) - kernel(x, sv_n.x));
        end
        
        if  abs( model.svs(idx_p).w) < 1e-5
            removeSupportVector(idx_p);
            if opt.DEBUG
                disp(['SMOStep: removing supportvector:' num2str(idx_p)] );
            end
            if (idx_n == length(model.svs) + 1)
                idx_n = idx_p;
            end
        end
        
         if  abs( model.svs(idx_n).w) < 1e-5
            removeSupportVector(idx_n);
        end
    end
end

function [] = removeSupportVector(idx)
    global model
    global opt
    sv = model.svs(idx);
    model.svs(idx) = [];
    sv.sp.ref = sv.sp.ref - 1;
    if  sv.sp.ref == 0
        sp_idx = find(model.sps == sv.sp);
        model.sps(sp_idx) = [];
    end
    
    if opt.DEBUG
        disp(['removeSupportVector: ' num2str(idx)]);
    end
    
end

function [] = processOld()
    global model
    global opt
    
    if isempty(model.sps) return; end
    idx = min(floor(rand() * length(model.sps)) + 1,length(model.sps));
    if opt.DEBUG
        %disp(['processOld: idx = ' num2str(idx)]);
    end
    ip = -1;
    max_grad = -inf;
    for i = 1:length(model.svs)
        sv = model.svs(i);
        if( model.sps(idx) ~= sv.sp ) 
            continue;
        end
        
        if (sv.g > max_grad && sv.w < model.m_C*(sv.idx == 1))
            
            ip = i;
            max_grad = sv.g;
        end
        
    end
    
    assert(ip ~= -1);
    if (ip == -1) 
        return;
    end
    
    [min_idx, min_grad] = MinGradient(idx);
    
    if opt.DEBUG
        %disp(['processOld: min_idx = ' num2str(min_idx) ', min_grad = ' num2str(min_grad)]);
    end
    
    in = -1;
    for i = 1:length(model.svs)
        sv = model.svs(i);
        if( model.sps(idx) ~= sv.sp ) 
            continue;
        end
        
        if (sv.idx == min_idx)
		
			in = i;
			break;
        end
        
    end
    
   
    
    if in == -1
        in = addSupportVector(idx, min_idx, min_grad);
    end
    
     if opt.DEBUG
        %disp(['processOld: ip = ' num2str(ip) ', in = ' num2str(in)]);
    end
    
    SMOStep(ip, in);
end

function [] = optimize()
    global model
    global opt
    if isempty(model.sps) return; end
    idx = min(floor(rand() * length(model.sps)) + 1,length(model.sps));
    
    if opt.DEBUG
        %disp(['optimize: idx = ' num2str(idx)]);
    end
    
    ip = -1;
    in = -1;
    max_grad = -inf;
    min_grad = inf;
    
    for i = 1:length(model.svs)
        sv = model.svs(i);
        if( model.sps(idx) ~= sv.sp ) 
            continue;
        end
        
        if (sv.g > max_grad && sv.w < model.m_C*(sv.idx == 1))
            
            ip = i;
            max_grad = sv.g;
        end
        
        if sv.g < min_grad
            in = i;
            min_grad = sv.g;
        end
        
    end
    
    assert(ip ~= -1 && in ~= -1);
    
    if (ip == -1 || in == -1)
	
		
		disp(['ERROR']);
		return;
    end
    
    SMOStep(ip, in);
end

function [] = reprocess()
     
     processOld();
     for i = 1:10
         optimize();
     end
end

function [] = BudgetMaintenance()

    global model
    global opt
    
    if opt.ssvm_BudgetSize > 0
        
        while length(model.svs) > opt.ssvm_BudgetSize
            BudgetMaintenanceRemove();
        end
    end
end



function [] = BudgetMaintenanceRemove()

    global model
    
    min_val = inf;
    
    ip = -1;
    in = -1;
    
    for i = 1:length(model.svs)
        sv = model.svs(i);
        
        %only handle the negative samples
        if (sv.w < 0.0)
            
            j = -1;
            for k = 1:length(model.svs)
                if (model.svs(k).w > 0 && (model.svs(k).sp == sv.sp))
                    j = k;
                    break;
                end
            end
            val = sv.w * sv.w *(kernel(sv.x,sv.x) + kernel(model.svs(j).x,model.svs(j).x) - 2.0*kernel(sv.x, model.svs(j).x));
            if val < min_val
                ip = j;
                in = i;
                min_val = val;
            end
        end
        
    end
    
    model.svs(ip).w = model.svs(ip).w + model.svs(in).w;
    removeSupportVector(in);
    if (ip == length(model.svs) + 1)
       ip = in;
    end
    if (model.svs(ip).w < 1e-5)
        removeSupportVector(ip);
    end
end