function varargout = recordVideo(varargin)
% RECORDVIDEO MATLAB code for recordVideo.fig
%      RECORDVIDEO, by itself, creates a new RECORDVIDEO or raises the existing
%      singleton*.
%
%      H = RECORDVIDEO returns the handle to a new RECORDVIDEO or the handle to
%      the existing singleton*.
%
%      RECORDVIDEO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECORDVIDEO.M with the given input arguments.
%
%      RECORDVIDEO('Property','Value',...) creates a new RECORDVIDEO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recordVideo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recordVideo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recordVideo

% Last Modified by GUIDE v2.5 09-Apr-2017 20:52:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recordVideo_OpeningFcn, ...
                   'gui_OutputFcn',  @recordVideo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before recordVideo is made visible.
function recordVideo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recordVideo (see VARARGIN)

% Choose default command line output for recordVideo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global vobj;
vobj=videoinput('winvideo',1,'MJPG_640x480');
%% Set Properties for Videoinput Object
vobj.TimeOut = Inf;
vobj.FrameGrabInterval = 1;
vobj.LoggingMode = 'disk&memory';
vobj.FramesPerTrigger = 100;
vobj.TriggerRepeat = Inf;

% Create an image object for previewing.
vidRes = vobj.VideoResolution;
nBands = vobj.NumberOfBands;
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(vobj, hImage);

% UIWAIT makes recordVideo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recordVideo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function z=thresholding2(image)
I=(double(image));
[H,W]=size(I);
for height=1:H
    for width=1:W
        if I(height,width)<24
            I(height,width)=0;
        else
            I(height,width)=1;
        end
    end
end
z=I;

function z=thresholding(image)
I=(double(image));
[H,W]=size(I);
for height=1:H
    for width=1:W
        if I(height,width)<32
            I(height,width)=0;
        else
            I(height,width)=255;
        end
    end
end
z=I;
function in=inversImage(image)
I=(double(image));
[H,W]=size(I);
for height=1:H
    for width=1:W
        if I(height,width)==0
            I(height,width)=255;
        else
            I(height,width)=0;
        end
    end
end
in=I;

function z= skeletonimage(image)
Imj=image;
%% CHANGE THE IMAGE HERE!!! 
I=(double(Imj)); 
%%Note: The image must be binary where 0=black and 1=white
%% objects must be composed of white pixels %I=im2double(I); 
%% I = original image 
[H,W]=size(I); 
%% height, width of image % binarization with threshold 125 if image is gray scale
    if max(I)~=1 % ~= tidak sama dengan
        for hi= 1 : H
            for wi = 1 : W
                if I(hi,wi)>125 % membandingkan elemen piksel ke hi, wi  yang merupakan warna abu mendekati putih
                   I(hi,wi)=1;% dirubah ke warna putih
                else
                    I(hi,wi)=0;%
                end
            end

        end 
    end

%%%%%%%%%%%%%%%%%->disini
J=I;	%% J = skeletonized image
K=I;	%% K = skeletonized image
B=0;	%% B = number of  zero neighbors
CHANGE=1000;
P=zeros(8);	%%	array	to	hold	the	8-neighborhood values 
jml=0;

%% OUTER LOOP - LOOP UNTIL NO PIXELS CHANGE%%
 while (CHANGE ~= 0)
        
    %% reset #of changes
    CHANGE =0;
        
        for r=3:H-1	%% row
            for c=2:W-2	%% column 
                if(J(r,c)==0)
                    %% find 8 neighborhood of pixel %%
                    P(10)=J(r-2,c-1);   P(11) = J(r-2,c);   P(12) = J(r-2,c+1);
                    P(9)=J(r-1,c-1);	P(2) = J(r-1,c);    P(3) = J(r-1,c+1);  P(13) = J(r-1,c+2);
                    P(8)=J(r,c-1);      P(1) = J(r,c);      P(4) = J(r,c+1);    P(14) = J(r,c+2);
                    P(7) =	J(r+1,c-1);	P(6) = J(r+1,c);    P(5) = J(r+1,c+1);  P(15) = J(r+1,c+2);

                    %% menghitung jumlah tetangga,bila B=1 maka termasuk endpoint %%
                    B=8-(P(2)+P(3)+P(4)+P(5)+P(6)+P(7)+P(8)+P(9));
                    
                     %0=black and 1=white
                    if ( (B>=2) & (B<=6) )
                        %0=black and 1=white
                        A1=0; 
                        if ( P(2)==1 & P(3)==0 )A1=A1+1;
                        end 
                        if ( P(3)==1 & P(4)==0 )A1=A1+1; 
                        end 
                        if ( P(4)==1 & P(5)==0 )A1=A1+1; 
                        end 
                        if ( P(5)==1 & P(6)==0 )A1=A1+1;
                        end 
                        if ( P(6)==1 & P(7)==0 )A1=A1+1;
                        end 
                        if ( P(7)==1 & P(8)==0 )A1=A1+1;
                        end 
                        if ( P(8)==1 & P(9)==0 )A1=A1+1;
                        end
                        if ( P(9)==1 & P(2)==0 )A1=A1+1; 
                        end
                       
                        if (A1==1)
                            A2=0; 
                            if ( P(11)==1 & P(12)==0 )A2=A2+1;
                            end 
                            if ( P(12)==1 & P(3)==0 )A2=A2+1; 
                            end 
                            if ( P(3)==1 & P(4)==0 )A2=A2+1; 
                            end 
                            if ( P(4)==1 & P(1)==0 )A2=A2+1;
                            end 
                            if ( P(1)==1 & P(8)==0 )A2=A2+1;
                            end 
                            if ( P(8)==1 & P(9)==0 )A2=A2+1;
                            end 
                            if ( P(9)==1 & P(10)==0 )A2=A2+1;
                            end
                            if ( P(10)==1 & P(11)==0 )A2=A2+1; 
                            end
                            
                            if ((P(2)==1 | P(4)==1 |P(8)==1) | A2 ~= 1)
                                A4=0; 
                                if ( P(3)==1 & P(13)==0 )A4=A4+1; 
                                end 
                                if ( P(13)==1 & P(14)==0 )A4=A4+1; 
                                end 
                                if ( P(14)==1 & P(15)==0 )A4=A4+1;
                                end 
                                if ( P(15)==1 & P(5)==0 )A4=A4+1;
                                end 
                                if ( P(5)==1 & P(6)==0 )A4=A4+1;
                                end 
                                if ( P(6)==1 & P(1)==0 )A4=A4+1;
                                end
                                if ( P(1)==1 & P(2)==0 )A4=A4+1; 
                                end
                                if ( P(2)==1 & P(3)==0 )A4=A4+1;
                                end 
                                
                                if((P(2)==1 | P(4)==1 |P(6)==1) | A4 ~= 1)
                                    K(r,c)=1;
                                    CHANGE=CHANGE+1;
                                end
                            end
                        end
                    end                 
                    end
                end 
            end 
               
    CHANGE ; 
        %% output # of changes this iteration 
        %% swap J with K
    J=K; 

    jml=jml+1; % tidak ada pengaruh diprogram
 end 
 

%%%%%%%%%%%%%%->

z=J;


% --- Executes on button press in ambil background.
function AmbilBackground_Callback(hObject, eventdata, handles)
% hObject    handle to AmbilBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    %warndlg('Pengambilan Background Selesai');
    global vobj;
    %global v;
    stop(vobj),delete(vobj),clear vobj
    %guidata(hObject,handles);
    
    
% --- Executes on button press in RekamGait.
function RekamGait_Callback(hObject, eventdata, handles)
% hObject    handle to RekamGait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %vobj=videoinput('winvideo',1,'MJPG_1280x720');
    

    %% Construct VideoWriter object and set Disk Logger Property
    %timenow = datestr(now,'hhMMss_ddmmyy');
    global vobj;
    global v;
    %v = VideoWriter(['newfile_', timenow,'.avi']);
    v = VideoWriter(['C:/Users/David/Documents/MATLAB/Video Record/video/GaitVideo.avi']);
    v.Quality = 50;
    v.FrameRate = 30;
    vobj.DiskLogger = v;

    % Select the source to use for acquisition.
    vobj.SelectedSourceName = 'input1';
    
    axes(handles.axes1);
    
    tic
    start(vobj)

    % Continue recording until figure gets closed
    %uiwait(f)


% --- Executes on button press in ekstrakBg.
function ekstrakBg_Callback(hObject, eventdata, handles)
% hObject    handle to ekstrakBg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global k;
global vid;
global vidWidth;
global vidHeight;
global mov;
global frames;
global Background;

%fileVid = ('GaitVideo.avi');
vid = VideoReader('C:/Users/David/Documents/MATLAB/Video Record/video/GaitVideo.avi');
vidWidth = vid.Width;
vidHeight = vid.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
frames = zeros(vidHeight,vidWidth,3,80);

k = 1;
while hasFrame(vid)
    disp(k);
    mov(k).cdata = readFrame(vid);
    frames(:,:,:,k) = mov(k).cdata;
    imwrite(mov(k).cdata,strcat(['image/cycle/Frame ',num2str(k),'.jpg']))
    k = k+1;
end

R = squeeze(frames(:,:,1,:));
G = squeeze(frames(:,:,2,:));
B = squeeze(frames(:,:,3,:));


R_back = uint8(mode(R,3));
G_back = uint8(mode(G,3));
B_back = uint8(mode(B,3));

Background = cat(3,R_back,G_back,B_back); 

warndlg('Preprocessing Selesai');
imwrite(Background,'image/background/background.jpg');

% --- Executes on button press in ekstrakFrame.
function ekstrakFrame_Callback(hObject, eventdata, handles)
% hObject    handle to ekstrakFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global k;
global vid;
global vidWidth;
global vidHeight;
global mov;
global frames;




% --- Executes on button press in skeleton.
function skeleton_Callback(hObject, eventdata, handles)
% hObject    handle to skeleton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathSiluet = 'image/siluet';
contentSiluet = dir(fullfile(pathSiluet,'*.jpg'));
for a=1:numel(contentSiluet)
    disp(a);
    fileSiluet = contentSiluet(a).name;
    % Open the file specified in filename, do your processing...
    siluetPath = strcat(pathSiluet,'/',fileSiluet);
    %CurrentFrame = uint8(frames(:,:,:,x));
    %TempatFrame = strcat('image/cycle/Frame',num2str(x),'.jpg');
    %CurrentSiluet = imread(siluetPath);
    
    citraSiluet=imread(siluetPath);
    citraSkeleton=skeletonimage(citraSiluet);
    
    %axes(handles.Skeleton);
    %imshow(citraSkeleton);
    %nama2=strcat('Skeleton-',num2str(a));
    %set(handles.namaSkeleton,'String',nama2);
    %proses simpan
    tmptCitraSkeleton=strcat('image/skeleton/skeleton_',num2str(a),'.jpg');
    %imwrite(citraSkeleton,tmptCitraSkeleton);
    imwrite(citraSkeleton,tmptCitraSkeleton);
   
end
  warndlg('Pembentukan Skeleton Selesai');


% --- Executes on button press in ekstraksiFitur.
function ekstraksiFitur_Callback(hObject, eventdata, handles)
% hObject    handle to ekstraksiFitur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in deteksi.
function deteksi_Callback(hObject, eventdata, handles)
% hObject    handle to deteksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frames;

TempatBg = strcat('image/background/background.jpg');
Background = imread(TempatBg);
path = 'image/cycle';
%fileName = '*.jpg';
contents = dir(fullfile(path,'*.jpg')); 
for x = 1:numel(contents)
    disp(x);
    filename = contents(x).name;
    % Open the file specified in filename, do your processing...
    imgPath = strcat(path,'/',filename);
    %CurrentFrame = uint8(frames(:,:,:,x));
    %TempatFrame = strcat('image/cycle/Frame',num2str(x),'.jpg');
    CurrentFrame = imread(imgPath);
    
    
    % Mengkonversi citra menjadi grayscale
    Background_gray = rgb2gray(Background);    
    CurrentFrame_gray = rgb2gray(CurrentFrame);
    
    % Pengurangan citra grayscale
    Subtraction1 = imsubtract(Background_gray,CurrentFrame_gray);
    Subtraction2 = imsubtract(CurrentFrame_gray,Background_gray);
    gabung = Subtraction1 + Subtraction2;
    ukuran = size(gabung);
    disp(ukuran);
    % Pembuatan masking dan proses cropping
    %[row,col] = find(bw2==1);
    [row,col] = find(gabung==1);
    h_bw = imcrop(gabung,[min(col) min(row) max(col)-min(col) max(row)-min(row)]);
    
    imwrite(h_bw,num2str(['image/foreground/foreground ',num2str(x),'.jpg']));
    %imwrite(imagePotong,tmptCitraPisah);
    %axes(handles.axes1);
end

foregPath = 'image/foreground';
%fileName = '*.jpg';
contentsFore = dir(fullfile(foregPath,'*.jpg'));
for x = 1:numel(contentsFore)
    disp(x);
    filename = contentsFore(x).name;
    % Open the file specified in filename, do your processing...
    imgPath = strcat(foregPath,'/',filename);
    CurrentFrame = imread(imgPath);
    
    Filter=medfilt2(CurrentFrame,[8 8]);% pake median filter
    imageThresholding=thresholding(Filter);
	se90=strel('line',12,90);
	se0=strel('line',12,0);
	BWsdil=imdilate(imageThresholding,[se90 se0]);
	BWdfill=imfill(BWsdil,'holes');
	se902=strel('line',17,90);
	se02=strel('line',17,0);
	BWsdil1=imdilate(BWdfill,[se902 se02]);
	se=strel('disk',12);
    BWfinal=imerode(BWsdil1,se);   
    imageSiluet=inversImage(BWfinal);
    %axes(handles.Siluet);
    %imshow(imageSiluet);
    %nama2=strcat('Siluet-',angka);
    %set(handles.namaSiluet,'String',nama2);
    [row,col] = find(imageSiluet==0);
    siluetPotong = imcrop(imageSiluet,[min(col) min(row) max(col)-min(col) max(row)-min(row)]);
    
    %proses penyimpanan
    tmptCitraSiluet=strcat('image/siluet/siluet ',num2str(x),'.jpg');
    imwrite(siluetPotong,tmptCitraSiluet);
end
warndlg('Deteksi Selesai');