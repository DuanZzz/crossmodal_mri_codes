function cp = cleanPathFromRelativeRefs( p )

sepPos = sort([0 strfind( p, '/' ) strfind( p, '\' ) length(p)+1]);
cp = '';
lenPartBefore = [];
for ii = 1 : (numel( sepPos ) - 1)
    if strcmp( p(sepPos(ii)+1:sepPos(ii+1)-1), '.' )
        continue
    elseif strcmp( p(sepPos(ii)+1:sepPos(ii+1)-1), '..' )
        if numel( lenPartBefore ) > 0
            cp(end-lenPartBefore(end)+1:end) = [];
            lenPartBefore(end) = [];
        else
            cp(end+1:end+sepPos(ii+1)-sepPos(ii)) = p(sepPos(ii)+1:sepPos(ii+1));
        end
    elseif sepPos(ii+1) - sepPos(ii) < 2  ...
            && sepPos(ii) > 0       % not root
        continue
    else
        lowerIdx = sepPos(ii);
        upperIdx = min( sepPos(ii+1), length(p) );
        lenPartBefore(end+1) = upperIdx - lowerIdx;
        cp(end+1:end+lenPartBefore(end)) = p(lowerIdx+1:upperIdx);
    end
end

cp = fullfile( cp );