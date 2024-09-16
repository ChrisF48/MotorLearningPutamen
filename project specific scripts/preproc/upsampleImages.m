% Copyright Christopher Fricke, University Leipzig Medical Center,
% Neurology 2024

folder = 'data\prep\coreg_indiv\datscan_normalized\Average';

fn = 'average_ct_noskull.nii';

mv = medicalVolume(fullfile(folder,fn));

targetVoxelSize = [0.5 0.5 0.5];
ratios = targetVoxelSize ./ mv.VoxelSpacing;
origSize = size(mv.Voxels);
newSize = round(origSize ./ ratios);

origRef = mv.VolumeGeometry;
origMapping = intrinsicToWorldMapping(origRef);
tform = origMapping.A;

newMapping4by4 = tform.* [ratios([2 1 3]) 1];
newMapping = affinetform3d(newMapping4by4);

newRef = medicalref3d(newSize,newMapping);
newRef = orient(newRef,origRef.PatientCoordinateSystem);

newVol = resample(mv,newRef);
write(newVol,fullfile(folder,sprintf('upsampled_%s',fn)));