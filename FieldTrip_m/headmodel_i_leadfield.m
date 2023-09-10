clear variables
restoredefaultpath

addpath %ścieżka_do_fieldtrip_toolbox
ft_defaults

load ./forward_modeling/mri_aligned_headshape
cfg            = [];
cfg.resolution = 1;

mri_resliced = ft_volumereslice(cfg, mri_aligned_headshape);

cfg        = [];
cfg.output = {'brain' 'skull' 'scalp'};

mri_segmented = ft_volumesegment(cfg, mri_resliced);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg             = [];
cfg.method      = 'projectmesh';
cfg.tissue      = 'brain';
cfg.numvertices = 3000;

mesh_brain = ft_prepare_mesh(cfg, mri_segmented);
mesh_brain = ft_convert_units(mesh_brain, 'm');

cfg             = [];
cfg.method      = 'projectmesh';
cfg.tissue      = 'skull';
cfg.numvertices = 2000;

mesh_skull = ft_prepare_mesh(cfg, mri_segmented);
mesh_skull = ft_convert_units(mesh_skull, 'm');

cfg             = [];
cfg.method      = 'projectmesh';
cfg.tissue      = 'scalp';
cfg.numvertices = 1000;

mesh_scalp = ft_prepare_mesh(cfg, mri_segmented);
mesh_scalp = ft_convert_units(mesh_scalp, 'm');

mesh_eeg = [mesh_brain mesh_skull mesh_scalp];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load ./forward_modeling/headmodel_dipoli.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
headmodel = headmodel_dipoli;
load elec.mat
elec = ft_convert_units(elec, 'm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scalp_index = 1;
cfg = [];
cfg.method = 'project'; 
cfg.headshape = headmodel.bnd(scalp_index); 

elec_realigned = ft_electroderealign(cfg, elec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg             = [];
cfg.headmodel   = headmodel; 
cfg.resolution  = 0.01; 
cfg.inwardshift = 0.005; 

sourcemodel = ft_prepare_sourcemodel(cfg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inside = sourcemodel;
outside = sourcemodel;

inside.pos = sourcemodel.pos(sourcemodel.inside, :);
outside.pos = sourcemodel.pos(~sourcemodel.inside, :);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg = [];
cfg.sourcemodel = sourcemodel; 
cfg.headmodel   = headmodel;  
cfg.elec        = elec_realigned; 

sourcemodel_and_leadfield = ft_prepare_leadfield(cfg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
