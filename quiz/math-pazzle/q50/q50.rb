#frozen_string_literal: true

# n * m (cm) の長方形があり、長さ 1cm ごとに正方形のマス目で区切られている。
# 左上の頂点をA、右下の頂点をBとしたとき、AからBへの最長経路を求めよ。
# ただし、以下の制約を守ること
# 1. 同一直線状の移動は2回まで(同じ経路の往復はOKだがその場合も2回とカウントする)
# 2. 進路がクロスしてもOK

module Q50

  # 深さ優先探索
  # 移動した経路を座標で保持
  # 同一直線状の経路の使用回数を配列で記録

  class << self
    N = 5 # 縦
    M = 6 # 横
    MAX = 0

    def main
      p process(0, 0)
    end

    def process(start_x, start_y)
      play(start_x, start_y, new_used_line_records)
    end

    def play(x, y, used_line_records)
      results = [
        move_and_record(x, y, 1, 0, used_line_records), # x + 1
        move_and_record(x, y, -1, 0, used_line_records), # x - 1
        move_and_record(x, y, 0, 1, used_line_records), # y + 1
        move_and_record(x, y, 0, -1, used_line_records), # y - 1
      ]


      # x, y, used_line_records = move_and_record(x, y, 1, 0, used_line_records) # x + 1
      # x, y, used_line_records = move_and_record(x, y, 0, 1, used_line_records) # y + 1
      # # 1,1
      # x, y, used_line_records = move_and_record(x, y, 1, 0, used_line_records) # x + 1
      # x, y, used_line_records = move_and_record(x, y, 0, 1, used_line_records) # y + 1
      # # 2,2
      # x, y, used_line_records = move_and_record(x, y, 1, 0, used_line_records) # x + 1
      # x, y, used_line_records = move_and_record(x, y, 0, 1, used_line_records) # y + 1
      # # 3,3
      # x, y, used_line_records = move_and_record(x, y, 1, 0, used_line_records) # x + 1
      # x, y, used_line_records = move_and_record(x, y, 0, 1, used_line_records) # y + 1
      # # 4,4
      # x, y, used_line_records = move_and_record(x, y, 1, 0, used_line_records) # x + 1
      # x, y, used_line_records = move_and_record(x, y, 0, 1, used_line_records) # y + 1
      # # 5,5
      # results = [move_and_record(x, y, 1, 0, used_line_records)] # x + 1

      result_counts = results.map do |(result_x, result_y, result_used_line_records)|
        next unless result_x
        next result_used_line_records.flatten.sum if goal?(result_x, result_y)
        play(result_x, result_y, result_used_line_records)
      end.compact

      result_counts.empty? ? MAX : result_counts.max
    end

    def move_and_record(x, y, move_x, move_y, used_line_records)
      next_x, next_y = move(x, y, move_x, move_y)
      return [false, false, []] unless valid_point?(next_x, next_y)

      move_line = detect_move_line(x, y, move_x, move_y)
      next_used_line_records = add_used_line_record(used_line_records, move_line)
      return [false, false, []] unless valid_route?(next_used_line_records)

      return [next_x, next_y, next_used_line_records]
    end

    def move(x, y, move_x, move_y)
      [x + move_x, y + move_y]
    end

    def add_used_line_record(used_line_records, move_line)
      next_used_line_records = new_used_line_records(used_line_records)

      used_lines_x, used_lines_y = next_used_line_records
      move_line_x, move_line_y = move_line
      used_lines_x[move_line_x] += 1 unless move_line_x.nil?
      used_lines_y[move_line_y] += 1 unless move_line_y.nil?

      next_used_line_records
    end

    def valid_point?(x, y)
      0 <= x && x <= M && 0 <= y && y <= N
    end

    def detect_move_line(x, y, move_x, move_y)
      move_x == 0 ? [x, nil] : [nil, y]
    end

    def valid_route?(used_line_records)
      used_line_records.flatten.all? { |n| n <= 2 }
    end

    def goal?(x, y)
      x == M && y == N
    end

    def new_used_line_records(used_line_records = nil)
      return [[0] * (M + 1), [0] * (N + 1)] if used_line_records.nil?

      [used_line_records[0].dup, used_line_records[1].dup]
    end
  end
end

Q50.main
