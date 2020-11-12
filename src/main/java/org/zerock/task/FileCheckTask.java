package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		return null;
	}

	@Scheduled(cron = "0 * * * * *")		//주기 제어
	public void checkFiles() throws Exception{
		log.warn("File Check Task run...................................");
		log.warn("===================================");
		
		//file list in database
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//ready for check file in directory with database file list
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		//image file has thumnail file
		fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get("C:\\upload", vo.getUploadPath() + "s_" + vo.getUuid() + "_" + vo.getFileName()))
				.forEach(p -> fileListPaths.add(p));
		
		log.warn("===================================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		//files in yesterday directory
		File targetDir =  Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("-----------------------------------------------");
		
		try {
			for(File file : removeFiles) {
				log.warn(file.getAbsolutePath());
				file.delete();
			}
		} catch (NullPointerException e) {
			
		}
	}
}
