#frozen_string_literal: true

# 2 * n 枚のカードを n 枚ずつに分け、それぞれ上から1枚ずつ取り出して重ね直す。これを1回のシャッフルとする。
# 2 * (n - 1) 回目のシャッフルで元の順番にもどる n は 1 <= n 1< 100 の範囲でいくつあるか。
# ex) n = 3 の場合のシャッフル
# 1回目: 1 2 3 4 5 6 -> 1 2 3 | 4 5 6 -> 1 4 2 5 3 6
# 2回目: 1 4 2 5 3 6 -> 1 4 2 | 5 3 6 -> 1 5 4 3 2 6
# 3回目: 1 5 4 3 2 6 -> 1 5 4 | 3 2 6 -> 1 3 5 2 4 6
# 4回目: 1 3 5 2 4 6 -> 1 3 5 | 2 4 6 -> 1 2 3 4 5 6

module Q51

  # 逐次探索
  # 終了時、2 * (n - 1) の約数かどうかで判定

  class << self
    RANGE = (1 .. 100).to_a

    def main
      answer = RANGE.filter do |n|
        process(n)
      end
      answer.size
    end

    def process(n)
      # カード生成
      cards = (1 .. 2 * n).to_a
      limit = 2 * (n - 1)

      # 2 * (n - 1)回シャッフル(一致したら終了)
      shuffle_count = restore_shuffle(cards, limit)
      # 2 * (n - 1)の約数かどうか判定
      shuffle_count && limit % shuffle_count == 0

      # 2 * (n - 1)回目に初めて戻るもののみ抽出する場合）
      # shuffle_count && limit == shuffle_count
    end

    def restore_shuffle(cards, limit)
      shuffled_cards = cards.dup

      limit.times do |i|
        shuffled_cards = shuffle(shuffled_cards)
        return i + 1 if shuffled_cards == cards
      end

      false
    end

    def shuffle(cards)
      size = cards.size
      half = cards.size / 2
      cards[0...half].zip(cards[half ... size]).flatten
    end
  end
end

p Q51.main
