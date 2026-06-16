function splitmat_check(filename,interesting_protocols,cell_number) ; %,path1)

% Example: 
%filename = '20181018';
%interesting_protocols = 1:2; 
%cell_number = '01' ; 

data = load(strcat(filename,'.mat')); 
names = fieldnames(data); 

%cd(path1)
%mkdir(filename)
%cd(filename)

for k=interesting_protocols
    
     myStruc = struct; 
     index = strfind(names,strcat('Trace_1_',num2str(k),'_'));
     empties = cellfun('isempty',index);
     index(empties) = {0}; 
     index = cell2mat(index) ;
     
     for p=1:length(names)
        if index(p)==1
            myStruc.(cell2mat(names(p))) = data.(cell2mat(names(p))); 
        end
     end
     
     save(strcat(filename,'_',cell_number,'_',num2str(k),'.mat'),'myStruc')
     %save(strcat(filename,'_',num2str(k),'.mat'),'myStruc')
end

end
