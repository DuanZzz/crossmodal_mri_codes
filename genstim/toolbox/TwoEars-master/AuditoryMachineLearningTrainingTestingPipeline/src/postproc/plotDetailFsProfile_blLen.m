function plotDetailFsProfile_blLen( featureNames, impacts, addTitle )

baseGrpsBlLen = {{'ratemap','blLen 0.2'},{'onsetStrength','blLen 0.2'},...
                 {'amsFeatures','blLen 0.2'},{'spectralFeatures','blLen 0.2'},...
                 {'ratemap','blLen 0.5'},{'onsetStrength','blLen 0.5'},...
                 {'amsFeatures','blLen 0.5'},{'spectralFeatures','blLen 0.5'},...
                 {'ratemap','blLen 1'},{'onsetStrength','blLen 1'},...
                 {'amsFeatures','blLen 1'},{'spectralFeatures','blLen 1'}};
fs = [];
nTotal = 0;
for ii = 1 : numel( baseGrpsBlLen )
    grpIdxs = getFeatureIdxs( featureNames, baseGrpsBlLen{ii} );
    grpImpact(ii) = sum( impacts(grpIdxs) );
    nTotal = nTotal + sum( impacts(grpIdxs) > 0 );
end
fig = figure('Name',['Feature Profile blLen' addTitle],'defaulttextfontsize', 12, ...
       'position', [0, 0, 400,400]);
% subplot(6,100,[1:55,101:155,201:255,301:355,401:455]);
% title( 'features over frequency' );
hold all;
hPlot = bar( [grpImpact(1),grpImpact(2),grpImpact(3),grpImpact(4);...
              grpImpact(5),grpImpact(6),grpImpact(7),grpImpact(8);...
              grpImpact(9),grpImpact(10),grpImpact(11),grpImpact(12)], ...
    ...%'FaceColor', [0.3 0.3 0.3], ...
    'EdgeColor', 'none',...
    'BarWidth', 1.0,...
    'BarLayout', 'stacked' );
% set( gca, 'xtick',log10(binr),'xticklabel', round(binr) );
set( gca, 'FontSize', 12, 'YGrid', 'on' );
% xlabel( 'freq (upper end of bin)' );
ylabel( 'impact' );
ylim( gca, [0 0.7] );
% xlim( gca, [1.85 4.1] );
rotateXLabels( gca, 60 );
legend( {'ratemap', 'onsetStrength', 'amsFeatures', 'spectralFeatures'}, 'Location', 'Best' );
% op = get( gca, 'OuterPosition');
% ip = get( gca, 'Position');
% subplot(6,100,[375:400,475:500]);
% title( 'ams modulation freqs' );
% mfGrpsL = cellfun( @(c)(c(1)=='m' && c(2)=='f' && ~isempty( str2num( c(3) ) )), allGrps );
% mfGrps = allGrps(mfGrpsL);
% mfGrpsNum = cellfun( @(c)( str2num( c(3:end) ) ), mfGrps );
% [mfGrpsNum,sortIdx] = sort( mfGrpsNum );
% mfGrps = mfGrps(sortIdx);
% mfGrps = cellfun( @(c)({{c}}), mfGrps );
% plotFsGrps( mfGrps, impacts, featureNames, addTitle, true, true );
% subplot(6,100,[75:100,175:200]);
% sfGrps = {{'centroid'},{'crest'},{'spread'},{'entropy'},{'brightness'},{'hfc'},{'decrease'},...
%           {'flatness'},{'flux'},{'kurtosis'},{'skewness'},{'irregularity'},{'rolloff'},{'variation'}};
% plotFsGrps( sfGrps, impacts, featureNames, addTitle, false, true, 'pie' );
% title( 'spectral features' );
% annotation( gcf, 'textbox',...
%     [ip(1)-0.1 op(2)-0.1 0.01 0.05],...
%     'String',{['#total ' num2str(nTotal)]},...
%     'FontSize',12,...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% 
% savePng( ['fsProf_' addTitle] );
