class Uexternal
  include ActiveModel::Model

  # the path to the uexternal file describing this object
  attr_accessor :file

  # list of material files used
  attr_accessor :materials

  # name of VED.dat file
  attr_accessor :ved_file

  # root of file names for thermal profiles (*.txt and *.bin)
  attr_accessor :thermal_profiles_root

  # stop when analysis for this thermal profile is completed
  attr_accessor :max_profiles

  # number of thermal profiles between saving restart file
  attr_accessor :restart_profiles

  # number of thermal profiles between generation of output file
  attr_accessor :output_profiles

  # file of warp3d output commands to be executed
  attr_accessor :output_commands_file

  # N1 = number of sequential thermal profiles over which to use a larger
  # number of warp3d load steps
  attr_accessor :n1

  # N2 = number of increased load steps to use (>= 1) for solution over these
  # profiles
  attr_accessor :n2

  # N3 = number of load steps per profile for all profiles after the number of
  # profiles dictated by N1
  attr_accessor :n3

  # For example,  N1 = 5, N2 = 10, N3 = 15
  # The first 5 profiles in any heating or cooling cycle will use 10 load steps
  # per profile. All load steps after that in that profile will use 15 load
  # steps per profile.  Then it starts again at the next heating or cooling
  # cycle.

  # Parse the file
  def self.parse(file)
    file = Pathname.new(file)
    contents = File.read(file.to_s).scan(/^[^!].*/).map(&:strip).reject(&:blank?)

    # Read backwards since it is simplest
    n3 = contents[-1]
    n1, n2 = contents[-2].split(',').map(&:strip)
    output_commands_file = contents[-3]
    restart_profiles, output_profiles = contents[-4].split(',').map(&:strip)
    max_profiles = contents[-5]
    thermal_profiles_root = contents[-6]
    ved_file = contents[-7]

    # Get materials
    num_mats = contents[0].to_i
    materials = contents[1, num_mats]

    new(
      file: file,
      n1: n1,
      n2: n2,
      n3: n3,
      output_commands_file: output_commands_file,
      restart_profiles: restart_profiles,
      output_profiles: output_profiles,
      max_profiles: max_profiles,
      thermal_profiles_root: thermal_profiles_root,
      ved_file: ved_file,
      materials: materials
    )
  end

  # Number of material files
  def num_materials
    materials.length
  end

  # Check that all the files listed in uexternal exist
  def valid?(thermal: false)
    root = file.dirname

    root.join(output_commands_file).file? &&
      root.join(ved_file).file? &&
      materials.all? {|f| root.join(f).file?} &&
      ( thermal ?
        root.join("#{thermal_profiles_root}.txt").file? &&
        root.join("#{thermal_profiles_root}.bin").file? : true
      )
  end
end
