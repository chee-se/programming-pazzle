#frozen_string_literal: true

# 円形に並んだ 2n 枚のカードがあり、先頭 n 枚のカードは白、末尾 n 枚のカードは黒のカードである。
# 連続する3枚のカードを選び、カードの色を反転させることを繰り返す。
# n = 8 のとき、白いカードと黒いカードが交互に並ぶ最小回数を求めよ

module Q49

  # 幅優先探索
  # どの位置を反転するかが重要で、反転する順番は関係ない。
  # 0～15の位置から反転する位置を選び、反転、終了判定を実施
  # 次の反転位置は、前回の反転位置の次から選ぶ

  class << self
    N = 8

    def main
      start = ("1" * N + "0" * N).to_i(2)
      goal = ("10" * N).to_i(2)
      p process(start, goal)
    end

    def process(cards, goal)
      @queue = [[cards, []]]

      until @queue.empty?
        cards, used_pos = @queue.shift
        usable_range = ((used_pos.last || -1) + 1)...(N * 2)

        usable_range.each do |rev|
          next_cards = reverse_cards(cards, rev)
          return used_pos.size + 1 if next_cards == goal

          @queue << [next_cards, used_pos + [rev]]
        end
      end
    end

    def reverse_cards(cards, pos)
      cards ^ reverse_mask[pos]
    end

    def reverse_mask
      @mask ||= (N * 2).times.map do |i|
        base = "1" * 3 + "0" * (N * 2 -3) + "1" * 3 + "0" * (N * 2 - 3)
        base.slice(i, N * 2).to_i(2)
      end
    end
  end
end

Q49.main
