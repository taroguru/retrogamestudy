#include "ubox.h"
//reference : https://www.usebox.net/jjm/ubox-msx-lib/ubox-lib-ref.html
#include <stdio.h>
#include <stdint.h>
#include "printf.h"
#define LOCAL
#include "tiles.h"
#include "mplayer.h"

//TILE
#define WHITESPACE_TILE 129 /* not white, black*/
#define A_TILE 162  /* 타일에서 A가 시작하는 시점 */
#define ASCII_A 65  /* 알파벳 A의 아스키 */
#define AT_TILE 128 /* 타일에서 @이 시작하는 시점 */
#define ASCII_SEPERATOR 31 /* 아스키 31. unit separator */

extern uint8_t SONG[];  // 외부 음원 데이터
extern uint8_t EFFECTS[];   //이펙트 데이터

#define EFX_CHAN_NO 2   //효과음이 출력되는 채널

enum effects
{
    EFX_NONE = 0,
    EFX_START,
    EFX_BATTERY,
    EFX_ELEVATOR,
    EFX_HIT,
    EFX_DEAD,
};

//한줄 쓰기. x, y 시작 좌표
void put_text(uint8_t x, uint8_t y, const uint8_t *text){
    while(*text){       
        ubox_put_tile(x++, y, *text++ - ASCII_A + A_TILE );
    }
}
// timer counter
int gcounter = 0;
int gcount=0;

void inc_count(){
    ++gcounter;
}

// 3.5. 과제.
int g_x = 0;
int g_y = 0;
void _putchar(char character)
{
    //줄바꿈 처리.
    if(character == '\n')   {
        g_x = 0;
        ++g_y;  // 개행문자 적용
    }
    else{
        ubox_put_tile(g_x++, g_y, character + 128 - 31);
    }
}


// 3주차: (2부 3-5장)! 

void main()
{
    char buffer[10];
    uint8_t wait_tick = 2;
    
    //초당 프레임 30으로 지정
    //NTSC클럭=1/60초마다 발생, 1씩 증가하며 2가 되면 로직 진행, 60/2=30fps 
    ubox_init_isr(1);   
    // 화면을 스크린 모드2 로 설정
    /*
    0	Screen 0	40x24 text mode
    1	Screen 1	32x24 colored text mode
    2	Screen 2	256x192 graphics mode
    3	Screen 3	64*48 block graphics multicolor mode
     */
    ubox_set_mode(2);
    //화면을 검은색으로 초기화
    //foreground, background, border
    ubox_set_colors(1,1,1);


    //화면 그리기를 ubox_disable_screen()과 ubox_enable_screen()사이에 넣어둔다
    //부분 갱신보다 전체를 한번에 그리는 효과
    ubox_disable_screen();  

    //타일과 타일컬러 베이스 설정
    ubox_set_tiles(tiles);
    ubox_set_tiles_colors(tiles_colors);

    //특정 타일로 화면을 다 그림. arguemnt는 타일 인덱스.
    ubox_fill_screen(WHITESPACE_TILE);

    //hello, world 쓰기
    put_text(11, 11, "HELLO, WORLD!!");

    //화면 접근을 활성화
    ubox_enable_screen();
    ubox_set_user_isr(inc_count);
    
    //play background music 
    mplayer_init(SONG, 0);
    mplayer_init_effects(EFFECTS);
    ubox_set_user_isr(mplayer_play);
    mplayer_play();

    printf("VAMPIRE SURVIORS 3\n");
    printf("HELLO\n");
    printf("HELLO");

    //다 돌았으니 마지막 출력물을 보여주는 상태로 유지
    while(1)
    {
        //초당 카운트 하나씩 올리기. 그런데 정확하게 30, 50, 60마다 증가하지 않는다.
        //궁금궁금???
        if(gcounter >= 150){
            gcount++;
            sprintf(buffer, "%d",gcount);
            put_text(3,3,buffer);
            gcounter = 0;
        }

        //keyscan
        if( ubox_read_keys(0) == UBOX_MSX_KEY_1)
            mplayer_play_effect_p(EFX_START, EFX_CHAN_NO, 0);
            
		if (ubox_read_keys(0) == UBOX_MSX_KEY_2)
            mplayer_play_effect_p(EFX_BATTERY, EFX_CHAN_NO, 0);

		if (ubox_read_keys(0) == UBOX_MSX_KEY_3)
            mplayer_play_effect_p(EFX_ELEVATOR, EFX_CHAN_NO, 0);
		
		if (ubox_read_keys(0) == UBOX_MSX_KEY_4)
            mplayer_play_effect_p(EFX_HIT, EFX_CHAN_NO, 0);
		
		if (ubox_read_keys(0) == UBOX_MSX_KEY_5)
            mplayer_play_effect_p(EFX_DEAD, EFX_CHAN_NO, 0);
        ubox_wait();
    }

}