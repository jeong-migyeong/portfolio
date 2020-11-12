package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor		/* replyCnt와 list를 생성자의 파라미터로 처리 */
public class ReplyPageDTO {

	/* 전체 댓글의 수와 댓글의 목록을 같이 가져옴 */
	private int replyCnt; /* 댓글 수 */
	private List<ReplyVO> list; /* 목록 */
}
