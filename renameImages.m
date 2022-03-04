% Re-nombra archivos
db_path = '\coco-train2014\';
Files = dir('.\coco-train2014\*.jpg');


fprintf('Re-indexing %d images ...\n', length(Files));

for k=1:length(Files)
   FileNames = Files(k).name;
   old_name = strcat(path_dir,db_path,FileNames);
   name = strcat('COCO_train2014_', num2str(k), '.jpg');
   new_name = strcat(path_dir,db_path,name);
   movefile(old_name, new_name)
end

fprintf('Finished\n');
