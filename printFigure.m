function [ ] = printFigure( figureHandle, filename )
%PRINTFIGURE Summary of this function goes here
%   Detailed explanation goes here

set(figureHandle,'PaperPositionMode','auto', 'InvertHardCopy', 'off');
print(figureHandle,[filename '.svg'],'-painters','-dsvg')

close(figureHandle)
end

