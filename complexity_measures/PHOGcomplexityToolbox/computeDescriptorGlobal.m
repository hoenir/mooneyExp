function descriptor = computeDescriptorGlobal(GradientValue, GradientAngle, bins, angle, levels,section)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  computes Pyramid Histogram of Oriented Gradient over 'levels' pyramid
%  levels using gradient values and directions
%
% INPUT:
%	GradientValue -- matrix of gradient values
%   GradientAngle -- matrix of gradient directions
%	bins -- Number of bins on the histogram, needs to be a multiple of 3
%	angle -- 180 or 360
%   levels -- number of pyramid levels
%   
% OUTPUT:
%	pyramid histogram of oriented gradients (phog descriptor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  descriptor = [];

  intervalSize = angle/bins;
  halfIntervalSize = (angle/bins)/2;

  %level 0

  ind = ( (GradientAngle >= angle-halfIntervalSize) | (GradientAngle < halfIntervalSize) );
  descriptor = [descriptor;sum(GradientValue(ind))];

  for b=1:(bins-1)

    ind = ( (GradientAngle >= (b*intervalSize)-halfIntervalSize) & (GradientAngle < ((b+1)*intervalSize)-halfIntervalSize) );
    descriptor = [descriptor;sum(GradientValue(ind))];

  end
  %local normalization
  descriptor=normalizeDescriptor(descriptor,bins);

  % other levels

   for l=1:levels

    cellSizeX = size(GradientAngle,2)/(section^l);
    cellSizeY = size(GradientAngle,1)/(section^l);

    if (cellSizeX < 1) || (cellSizeY < 1)

      error('computePHOG.m: cell size < 1, adjust number of levels');

    end

    for j=1:(section^l)
    
      leftX = 1+uint16((j-1)*cellSizeX);
      rightX = uint16(j*cellSizeX);

      for i=1:(section^l)

        topY = 1+uint16((i-1)*cellSizeY);
        bottomY = uint16(i*cellSizeY);

        GradientValueCell = GradientValue(topY:bottomY, leftX:rightX);
        GradientAngleCell = GradientAngle(topY:bottomY, leftX:rightX);
            
        ind = ( (GradientAngleCell >= angle-halfIntervalSize) | (GradientAngleCell < halfIntervalSize) );
%        descriptor = [descriptor;sum(GradientValueCell(ind))];
        local_descriptor=[sum(GradientValueCell(ind))];

        for b=1:(bins-1)

          ind = ( (GradientAngleCell >= (b*intervalSize)-halfIntervalSize) & (GradientAngleCell < ((b+1)*intervalSize)-halfIntervalSize) );
        %  descriptor = [descriptor;sum(GradientValueCell(ind))];
          local_descriptor = [local_descriptor;sum(GradientValueCell(ind))];

        end
        
        local_descriptor=normalizeDescriptor(local_descriptor,bins);
        
        
        descriptor=[descriptor;local_descriptor];
      end        

    end

   end
   
   descriptor=normalizeDescriptorGlobal(descriptor);
   
      
  
   
end % of function computeDescriptor

