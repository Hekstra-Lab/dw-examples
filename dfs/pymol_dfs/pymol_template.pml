
#change these variables!! 
# vvvvv
dataset="P0115"
num=2
# ^^^^^

#set your path to this folder here!
cd dw/pymol_dfs/ 


#settings
bg_color white
set ray_opaque_background, true
set map_auto_expand_sym, 1
set mesh_width, 1.2
set antialias, 1
set direct, 0.5
util.ray_shadows('none')
set cartoon_gap_cutoff, 0
set ray_volume

cmd.load("UCSF-"+dataset+"-pandda-model_"+str(num)+".pdb","holo")
util.cbaw holo

set valence, 0
hide everything
sele ligand, resi 201 and chain C
show cartoon, (not ligand) and (not hydrogens)
show sticks, ligand and (not hydrogens)
set stick_radius, 0.2, not hydrogens
show sticks, resi 154-157
show sticks, resi 22
show sticks, resi 128-133
hide cartoon, resi 129-133
hide cartoon, resi 44-55

cmd.load_mtz("wdm_"+str(num)+"_best.mtz","Fobs","F_on","Phi")
# cmd.load_mtz("wdm_"+str(num)+"_best.mtz","Fobs","F_on","Phi")
# map_double Fobs
cmd.load_mtz("wdm_"+str(num)+"_best.mtz", "df_best", "DF", "Phi")
map_double df_best
cmd.load_mtz("wdm_"+str(num)+"_univariate.mtz", "df_univariate", "DF", "Phi")
map_double df_univariate

# isomesh Fobs_mesh, Fobs, 1.5, ligand, carve=1.5
# color gray, Fobs_mesh
isomesh df_best_mesh, df_best, 3.0, ligand, carve=1.5
color 0x0571b0, df_best_mesh

cmd.set_view((-0.9199408888816833, 0.34247779846191406, -0.1907799392938614, -0.2290385514497757, -0.07459352910518646, 0.9705454111099243, 0.31816330552101135, 0.9365552067756653, 0.14706364274024963, 0.0, 0.0, -39.80332946777344, -44.95423126220703, -29.24036407470703, 2.3783278465270996, 34.238868713378906, 45.36779022216797, -20.0))
center ligand

cmd.png("png/multivariate_"+dataset+"_"+str(num)+".png",dpi=900)

delete df_best_mesh

isomesh df_univariate_mesh, df_univariate, 3.0, ligand, carve=1.5
color 0x0571b0, df_univariate_mesh

cmd.png("png/univariate_"+dataset+"_"+str(num)+".png",dpi=900)
quit
